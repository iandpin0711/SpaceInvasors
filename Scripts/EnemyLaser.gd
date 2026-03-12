extends Area2D

# Called when the node enters the scene
func _ready():
	# Play effects for all laser parts
	$Laser_1.play("effect")
	$Laser_2.play("effect")
	$Laser_3.play("effect")
	$Laser_4.play("effect")
	$Laser_5.play("effect")

# Called when the laser hits something
func _on_body_entered(body):
	# Only affect objects that can take damage
	if body.has_method("take_damage"):
		# Deal damage
		body.take_damage()
