extends Area2D

const SPEED = 500
const RANGE = 1200
var direction = Vector2.DOWN
var travelled_distance = 0

func _ready():
	$AnimatedSprite2D.play("bullet")

func _physics_process(delta):
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
		queue_free()
