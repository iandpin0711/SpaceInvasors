extends Camera2D

var shakeBaseAmount = 1.0
var shakeDampening = 0.075
var shakeAmount = 0.0

func _process(delta):
	if shakeAmount > 0:
		position.x = randf_range(-shakeAmount, shakeBaseAmount) * shakeAmount
		position.y = randf_range(-shakeAmount, shakeBaseAmount) * shakeAmount
		shakeAmount = lerp(shakeAmount, 0.0, shakeDampening)
	else:
		position = Vector2(0, 0)

func shake(magnitude):
	shakeAmount += magnitude
