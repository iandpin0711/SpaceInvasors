extends Area2D

func _ready():
	$Laser_1.play("effect")
	$Laser_2.play("effect")
	$Laser_3.play("effect")
	$Laser_4.play("effect")
	$Laser_5.play("effect")


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
