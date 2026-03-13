extends Camera2D

# Base amount of shake
var shakeBaseAmount = 1.0
# How fast shake decreases
var shakeDampening = 0.075
# Current shake intensity
var shakeAmount = 0.0

# Called every frame
func _process(delta):
	if shakeAmount > 0:
		# Randomly move camera within shake range
		position.x = randf_range(-shakeAmount, shakeBaseAmount) * shakeAmount
		position.y = randf_range(-shakeAmount, shakeBaseAmount) * shakeAmount
		# Reduce shake over time
		shakeAmount = lerp(shakeAmount, 0.0, shakeDampening)
	else:
		# Reset camera to original position
		position = Vector2(0, 0)

# Call to start camera shake
func shake(magnitude):
	shakeAmount += magnitude
