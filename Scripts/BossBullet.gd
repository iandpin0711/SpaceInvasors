extends Area2D


# --------------------------------------------------
# Movement configuration
# --------------------------------------------------
# Constant speed of the projectile
const SPEED = 500

# Maximum distance the projectile can travel
const RANGE = 1200

# Direction of movement (default is downward)
var direction = Vector2.DOWN

# Tracks how far the projectile has travelled
var travelled_distance = 0


# --------------------------------------------------
# Physics update
# --------------------------------------------------
# Runs every physics frame
func _physics_process(delta):

	# Move the projectile in the specified direction
	position += direction * SPEED * delta
	
	# Update travelled distance
	travelled_distance += SPEED * delta

	# Remove the projectile if it exceeds its range
	if travelled_distance > RANGE:
		queue_free()


# --------------------------------------------------
# Collision handling
# --------------------------------------------------
# Triggered when the projectile collides with a body
func _on_body_entered(body):

	# Check if the body has a damage method
	if body.has_method("take_damage"):

		# Apply damage to the body
		body.take_damage()

		# Destroy the projectile after impact
		queue_free()
