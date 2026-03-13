extends CharacterBody2D

# Vertical speed of the enemy
const VERTICAL_SPEED = 100.0
# Max distance the enemy moves before disappearing
const RANGE = 1200
# Time between shots
const SHOOT_INTERVAL = 1.1

# Timer for shooting
var shoot_timer = SHOOT_INTERVAL
# Tracks how far the enemy has moved
var travelled_distance = 0
var health = 5
var dying = false

# Enemy bullet scene
var pEnemyBullet = preload("res://Assets/BulletEnemy.tscn")

# Setup animations and effects
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
	
	# Remove enemy if it goes too far
	if travelled_distance > RANGE:
		queue_free()

	# Handle shooting
	shoot_timer -= delta
	if shoot_timer <= 0.0:
		# Spawn a bullet
		var bullet = pEnemyBullet.instantiate()
		bullet.global_position = $BulletPosition.global_position
		get_tree().current_scene.add_child(bullet)
		# Reset shoot timer
		shoot_timer = SHOOT_INTERVAL

# Handle damage taken
func take_damage():
	if dying:
		return

	# Reduce health
	health -= 1
	if health <= 0:
		dying = true
		# Reset shoot timer
		shoot_timer = SHOOT_INTERVAL
		# Add score
		Signals.score += 10
		Signals.emit_signal("on_score_increment", 10)
		# Disable collisions and effects
		$CollisionShape2D.set_deferred("disabled", true)
		$IdleEffect.visible = false
		# Play death animation
		$Sprite2D.play("die")

# When death animation finishes
func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "die":
		queue_free()
