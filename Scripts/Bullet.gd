extends Area2D

# Projectile speed
const SPEED = 700
# Maximum distance it can travel
const RANGE = 1200

# Movement direction (up by default)
var direction = Vector2.UP
# Tracks how far it has moved
var travelled_distance = 0

# Called every physics frame
func _physics_process(delta):
	# Move in the chosen direction
	position += direction * SPEED * delta
	# Add to travelled distance
	travelled_distance += SPEED * delta
	# Remove if it went too far
	if travelled_distance > RANGE:
		queue_free()

# Called when projectile hits something
func _on_body_entered(body):
	# Only affect objects that can take damage
	if body.has_method("take_damage"):
		# Deal damage
		body.take_damage()
		# Destroy projectile
		queue_free()
