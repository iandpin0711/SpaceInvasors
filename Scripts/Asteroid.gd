extends CharacterBody2D

# Movement configuration
var minSpeed = 40
var maxSpeed = 60
var minRotationRate = -20
var maxRotationRate = 20
var speed = 0
var rotationRate = 0

# Health
var health = 50
var dying = false

# Max distance it can travel
const RANGE = 1200
var travelled_distance = 0

# Called when the node enters the scene
func _ready():
	# Pick random speed and rotation
	speed = randf_range(minSpeed, maxSpeed)
	rotationRate = randf_range(minRotationRate, maxRotationRate)

# Called every physics frame
func _physics_process(delta):
	# Rotate the object
	rotation_degrees += rotationRate * delta
	# Move it down
	position.y += speed * delta
	# Track how far it has moved
	travelled_distance += speed * delta
	
	# Remove it if it went too far
	if travelled_distance > RANGE:
		queue_free()

# Called when the object takes damage
func take_damage():
	# Ignore if already dying
	if dying:
		return
	
	# Reduce health
	health -= 1

	# Check if dead
	if health <= 0:
		dying = true
		# Add points and play death animation
		Signals.score += 50
		Signals.emit_signal("on_score_increment", 50)
		$Sprite2D.play("die")

# Called when a Sprite2D animation finishes
func _on_sprite_2d_animation_finished():
	# Remove object after death animation
	if $Sprite2D.animation == "die":
		queue_free()
