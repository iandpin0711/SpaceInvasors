extends CharacterBody2D

const VERTICAL_SPEED = 450.0
const RANGE = 1200

var travelled_distance = 0
var health = 3
var dying = false

@onready var collision_shape = $CollisionShape2D


func _ready():
	$IdleEffect.play("effect")
	$Sprite2D.play("idle")


func _physics_process(delta):
	if dying:
		return
	
	position.y += VERTICAL_SPEED * delta
	travelled_distance += VERTICAL_SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()


func take_damage():
	if dying:
		return
	
	health -= 1
	if health <= 0:
		dying = true
		Signals.score += 30
		Signals.emit_signal("on_score_increment", 30)
		$IdleEffect.visible = false
		$Sprite2D.play("die")
		if collision_shape:
			collision_shape.set_deferred("disabled", true)


func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "die":
		queue_free()
