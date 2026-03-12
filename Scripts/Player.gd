class_name Player
extends CharacterBody2D

var pBullet = preload("res://Assets/Bullet.tscn")
const SPEED = 250.0
const MAX_LIVES = 3
const DAMAGE_INVUL_TIME = 3
var lives = MAX_LIVES
var invulnerable = false
var triple_shot = false

@onready var shoot_sound = $ShootSound
@onready var damage_sound = $DamageSound
@onready var shoot_cooldown = %ShootCooldown
@onready var shield = $Shield
@onready var invulnerable_timer = %InvincibilityTimer
@onready var triple_timer = $TripleShotTimer
@onready var sprite = %Sprite2D
@onready var bullet_left = %BulletPositionLeft
@onready var bullet_right = %BulletPositionRight

func _ready():
	shield.visible = false
	Signals.emit_signal("on_player_life_changed", lives)
	$AnimatedSprite2D.play("effect")
	$Shield.play("effect")
	update_ship_sprite()

func _process(delta):
	if Input.is_action_pressed("shoot") and shoot_cooldown.is_stopped():
		var bullet = pBullet.instantiate()
		bullet.global_position = %BulletPosition.global_position
		get_tree().current_scene.add_child(bullet)
		shoot_sound.stop()
		shoot_sound.play()
		
		if triple_shot:
			var bullet_left_instance = pBullet.instantiate()
			bullet_left_instance.global_position = bullet_left.global_position
			get_tree().current_scene.add_child(bullet_left_instance)

			var bullet_right_instance = pBullet.instantiate()
			bullet_right_instance.global_position = bullet_right.global_position
			get_tree().current_scene.add_child(bullet_right_instance)

		shoot_cooldown.start()

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	
	var viewReact = get_viewport_rect()
	position.x = clamp(position.x, 0, viewReact.size.x)
	position.y = clamp(position.y, 0, viewReact.size.y)
	
	if invulnerable:
		shield.visible = true
		sprite.modulate.a = 0.5
	else:
		shield.visible = false
		sprite.modulate.a = 1.0

func take_damage():
	if invulnerable:
		return
	damage_sound.stop()
	damage_sound.play()
	lives -= 1
	Signals.emit_signal("on_player_life_changed", lives)
	update_ship_sprite()
	var cam = get_tree().current_scene.find_child("Cam", true, false)
	if cam:
		cam.shake(3)
	
	if lives <= 0:
		call_deferred("_go_to_game_over")
	else:
		applyShield(DAMAGE_INVUL_TIME)

func _go_to_game_over():
	queue_free()
	get_tree().change_scene_to_file("res://Scene/GameOver.tscn")

func update_ship_sprite():
	match lives:
		3:
			sprite.texture = preload("res://Textures/Sprite/Ship/base_ship.png")
		2:
			sprite.texture = preload("res://Textures/Sprite/Ship/damaged_ship.png")
		1:
			sprite.texture = preload("res://Textures/Sprite/Ship/very_damaged_ship.png")

func applyShield(time):
	invulnerable = true
	shield.visible = true
	sprite.modulate.a = 0.5
	invulnerable_timer.wait_time = time
	invulnerable_timer.start()

func applyTripleShot(time):
	triple_shot = true
	triple_timer.wait_time = time
	triple_timer.start()

func _on_invincibility_timer_timeout():
	invulnerable = false
	shield.visible = false
	sprite.modulate.a = 1.0

func _on_triple_shot_timer_timeout():
	triple_shot = false
