extends CharacterBody2D

const VERTICAL_SPEED = 100.0
const RANGE = 1200
const SHOOT_INTERVAL = 1.1

var shoot_timer = SHOOT_INTERVAL
var travelled_distance = 0
var health = 5
var dying = false

var pEnemyBullet = preload("res://Assets/BulletEnemy.tscn")


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

	shoot_timer -= delta
	if shoot_timer <= 0.0:
		var bullet = pEnemyBullet.instantiate()
		bullet.global_position = $BulletPosition.global_position
		get_tree().current_scene.add_child(bullet)
		shoot_timer = SHOOT_INTERVAL


func take_damage():
	if dying:
		return

	health -= 1
	if health <= 0:
		dying = true
		shoot_timer = SHOOT_INTERVAL
		Signals.score += 10
		Signals.emit_signal("on_score_increment", 10)
		$CollisionShape2D.set_deferred("disabled", true)
		$IdleEffect.visible = false
		$Sprite2D.play("die")


func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "die":
		queue_free()
