extends CharacterBody2D


# --------------------------------------------------
# Movement configuration
# --------------------------------------------------
# Minimum and maximum forward speed
var minSpeed = 40
var maxSpeed = 60

# Minimum and maximum rotation speed
var minRotationRate = -20
var maxRotationRate = 20

# Actual values assigned at runtime
var speed = 0
var rotationRate = 0


# --------------------------------------------------
# Health and death state
# --------------------------------------------------
var health = 50
var dying = false


# --------------------------------------------------
# Travel distance control
# --------------------------------------------------
# Maximum distance the object can travel before being removed
const RANGE = 1200

# Tracks the total distance travelled
var travelled_distance = 0


# --------------------------------------------------
# Initialization
# --------------------------------------------------
# Called when the node enters the scene
func _ready():
	# Assign random movement values within the allowed ranges
	speed = randf_range(minSpeed, maxSpeed)
	rotationRate = randf_range(minRotationRate, maxRotationRate)


# --------------------------------------------------
# Physics update
# --------------------------------------------------
# Runs every physics frame
func _physics_process(delta):

	# Apply continuous rotation
	rotation_degrees += rotationRate * delta

	# Move the object downward
	position.y += speed * delta

	# Track travelled distance
	travelled_distance += speed * delta
	
	# Remove the object if it exceeds its allowed range
	if travelled_distance > RANGE:
		queue_free()


# --------------------------------------------------
# Damage handling
# --------------------------------------------------
# Called when the object takes damage
func take_damage():

	# Prevent damage processing if already dying
	if dying:
		return
	
	# Reduce health
	health -= 1

	# Check if health reached zero
	if health <= 0:
		dying = true

		# Add score to the global score system
		Signals.score += 50
		Signals.emit_signal("on_score_increment", 50)

		# Play death animation
		$Sprite2D.play("die")


# --------------------------------------------------
# Animation finished callback
# --------------------------------------------------
# Triggered when a Sprite2D animation ends
func _on_sprite_2d_animation_finished():

	# If the finished animation is the death animation,
	# remove the object from the scene
	if $Sprite2D.animation == "die":
		queue_free()
