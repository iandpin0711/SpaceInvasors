extends CharacterBody2D

# Vertical speed of the enemy
const VERTICAL_SPEED = 100.0
# Max distance the enemy moves before disappearing
const RANGE = 1200

# Tracks how far the enemy has moved
var travelled_distance = 0
var health = 5
var invulnerable = false
var dying = false

# Nodes
@onready var shield = $Shield
@onready var shield_timer = $ShieldTimer
@onready var collision_shape = $CollisionShape2D

# Setup animations and shield
func _ready():
	$IdleEffect.play("effect")
	$Shield.play("effect")
	$Sprite2D.play("idle")
	# Hide shield at start
	shield.visible = false
	
	# Start shield timer with random duration
	shield_timer.wait_time = randf_range(2.0, 4.0)
	shield_timer.start()

# Called every physics frame
func _physics_process(delta):
	if dying:
		return
	
	# Move enemy down
	position.y += VERTICAL_SPEED * delta
	# Update travelled distance
	travelled_distance += VERTICAL_SPEED * delta
	
	# Remove enemy if it went too far
	if travelled_distance > RANGE:
		queue_free()

# Handle damage taken
func take_damage():
	if invulnerable or dying:
		return
	
	# Reduce health
	health -= 1
	if health <= 0:
		dying = true
		# Add score
		Signals.score += 20
		Signals.emit_signal("on_score_increment", 20)
		# Stop shield timer
		shield_timer.stop()
		invulnerable = false
		shield.visible = false
		$IdleEffect.visible = false
		# Play death animation
		$Sprite2D.play("die")
		if collision_shape:
			collision_shape.set_deferred("disabled", true)

# Called when shield timer finishes
func _on_shield_timer_timeout():
	if invulnerable:
		# Turn off shield
		invulnerable = false
		shield.visible = false
		shield_timer.wait_time = randf_range(3.0, 6.0)
	else:
		# Turn on shield
		invulnerable = true
		shield.visible = true
		shield_timer.wait_time = randf_range(2.0, 4.0)
	
	# Restart shield timer
	shield_timer.start()

# Called when sprite animation ends
func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "die":
		# Remove enemy from scene
		queue_free()
