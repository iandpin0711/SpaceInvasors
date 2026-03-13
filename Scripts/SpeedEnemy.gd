extends CharacterBody2D

# Vertical movement speed of the enemy
const VERTICAL_SPEED = 450.0
# Max distance enemy can travel before disappearing
const RANGE = 1200

# Tracks how far the enemy has moved
var travelled_distance = 0
var health = 3
var dying = false

# Collision shape node
@onready var collision_shape = $CollisionShape2D

# Called when scene starts
func _ready():
	$IdleEffect.play("effect")
	$Sprite2D.play("idle")

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

# Called when enemy takes damage
func take_damage():
	if dying:
		return
	
	# Reduce health
	health -= 1
	if health <= 0:
		dying = true
		# Add score
		Signals.score += 30
		Signals.emit_signal("on_score_increment", 30)
		# Hide idle effect
		$IdleEffect.visible = false
		# Play death animation
		$Sprite2D.play("die")
		if collision_shape:
			collision_shape.set_deferred("disabled", true)

# Called when sprite animation finishes
func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "die":
		# Remove enemy from scene
		queue_free()
