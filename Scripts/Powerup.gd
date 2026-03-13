class_name Powerup
extends Area2D

# Movement speed of the power-up
var powerupMoveSpeed = 100
# Tracks how far the power-up has moved
var travelled_distance = 0
# Max distance before disappearing
const RANGE = 1200

# Called every physics frame
func _physics_process(delta):
	# Calculate movement distance
	var distance = powerupMoveSpeed * delta
	# Move power-up down
	position.y += distance
	# Update travelled distance
	travelled_distance += distance
	
	# Remove if it went too far
	if travelled_distance > RANGE:
		queue_free()

# Apply power-up effect to player
func applyPowerup(player):
	pass

# Called when power-up touches something
func _on_body_entered(body):
	# Only affect player
	if body is Player:
		# Apply power-up effect
		applyPowerup(body)
		# Remove power-up from scene
		queue_free()
