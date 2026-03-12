extends CharacterBody2D

const VERTICAL_SPEED = 100.0
const RANGE = 1200

var travelled_distance = 0
var health = 5
var invulnerable = false
var dying = false

@onready var shield = $Shield
@onready var shield_timer = $ShieldTimer
@onready var collision_shape = $CollisionShape2D


func _ready():
	$IdleEffect.play("effect")
	$Shield.play("effect")
	$Sprite2D.play("idle")
	shield.visible = false
	
	shield_timer.wait_time = randf_range(2.0, 4.0)
	shield_timer.start()


func _physics_process(delta):
	if dying:
		return
	
	position.y += VERTICAL_SPEED * delta
	travelled_distance += VERTICAL_SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()


func take_damage():
	if invulnerable or dying:
		return
	
	health -= 1
	if health <= 0:
		dying = true
		Signals.score += 20
		Signals.emit_signal("on_score_increment", 20)
		shield_timer.stop()
		invulnerable = false
		shield.visible = false
		$IdleEffect.visible = false
		$Sprite2D.play("die")
		if collision_shape:
			collision_shape.set_deferred("disabled", true)


func _on_shield_timer_timeout():
	if invulnerable:
		invulnerable = false
		shield.visible = false
		shield_timer.wait_time = randf_range(3.0, 6.0)
	else:
		invulnerable = true
		shield.visible = true
		shield_timer.wait_time = randf_range(2.0, 4.0)
	
	shield_timer.start()


func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "die":
		queue_free()
