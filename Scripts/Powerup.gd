class_name Powerup
extends Area2D

var powerupMoveSpeed = 100
var travelled_distance = 0
const RANGE = 1200

func _physics_process(delta):
	var distance = powerupMoveSpeed * delta
	position.y += distance
	travelled_distance += distance
	
	if travelled_distance > RANGE:
		queue_free()

func applyPowerup(player):
	pass

func _on_body_entered(body):
	if body is Player:
		applyPowerup(body)
		queue_free()
