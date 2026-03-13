class_name Player
extends CharacterBody2D

# Player bullet scene
var pBullet = preload("res://Assets/Bullet.tscn")
# Movement speed
const SPEED = 250.0
# Max lives
const MAX_LIVES = 3
# Time player is invulnerable after damage
const DAMAGE_INVUL_TIME = 3

var lives = MAX_LIVES
var invulnerable = false
var triple_shot = false

# Nodes
@onready var shoot_sound = $ShootSound
@onready var damage_sound = $DamageSound
@onready var shoot_cooldown = %ShootCooldown
@onready var shield = $Shield
@onready var invulnerable_timer = %InvincibilityTimer
@onready var triple_timer = $TripleShotTimer
@onready var sprite = %Sprite2D
@onready var bullet_left = %BulletPositionLeft
@onready var bullet_right = %BulletPositionRight

# Called when scene starts
func _ready():
	# Hide shield at start
	shield.visible = false
	# Update UI with current lives
	Signals.emit_signal("on_player_life_changed", lives)
	$AnimatedSprite2D.play("effect")
	$Shield.play("effect")
	# Set sprite according to lives
	update_ship_sprite()

# Called every frame
func _process(delta):
	# Handle shooting input
	if Input.is_action_pressed("shoot") and shoot_cooldown.is_stopped():
		# Spawn main bullet
		var bullet = pBullet.instantiate()
		bullet.global_position = %BulletPosition.global_position
		get_tree().current_scene.add_child(bullet)
		shoot_sound.stop()
		shoot_sound.play()
		
		# Spawn side bullets if triple shot active
		if triple_shot:
			var bullet_left_instance = pBullet.instantiate()
			bullet_left_instance.global_position = bullet_left.global_position
			get_tree().current_scene.add_child(bullet_left_instance)

			var bullet_right_instance = pBullet.instantiate()
			bullet_right_instance.global_position = bullet_right.global_position
			get_tree().current_scene.add_child(bullet_right_instance)

		# Restart shoot cooldown
		shoot_cooldown.start()

# Called every physics frame
func _physics_process(delta):
	# Get input direction
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	
	# Keep player inside screen
	var viewReact = get_viewport_rect()
	position.x = clamp(position.x, 0, viewReact.size.x)
	position.y = clamp(position.y, 0, viewReact.size.y)
	
	# Show shield and make sprite semi-transparent if invulnerable
	if invulnerable:
		shield.visible = true
		sprite.modulate.a = 0.5
	else:
		shield.visible = false
		sprite.modulate.a = 1.0

# Called when player takes damage
func take_damage():
	if invulnerable:
		return

	# Play damage sound
	damage_sound.stop()
	damage_sound.play()
	# Reduce lives and update UI
	lives -= 1
	Signals.emit_signal("on_player_life_changed", lives)
	update_ship_sprite()
	# Shake camera if exists
	var cam = get_tree().current_scene.find_child("Cam", true, false)
	if cam:
		cam.shake(3)
	
	# Check for game over
	if lives <= 0:
		call_deferred("_go_to_game_over")
	else:
		# Apply temporary shield
		applyShield(DAMAGE_INVUL_TIME)

# Go to game over scene
func _go_to_game_over():
	queue_free()
	get_tree().change_scene_to_file("res://Scene/GameOver.tscn")

# Update sprite based on remaining lives
func update_ship_sprite():
	match lives:
		3:
			sprite.texture = preload("res://Textures/Sprite/Ship/base_ship.png")
		2:
			sprite.texture = preload("res://Textures/Sprite/Ship/damaged_ship.png")
		1:
			sprite.texture = preload("res://Textures/Sprite/Ship/very_damaged_ship.png")

# Apply temporary shield
func applyShield(time):
	invulnerable = true
	shield.visible = true
	sprite.modulate.a = 0.5
	invulnerable_timer.wait_time = time
	invulnerable_timer.start()

# Apply triple shot power-up
func applyTripleShot(time):
	triple_shot = true
	triple_timer.wait_time = time
	triple_timer.start()

# Called when invulnerability ends
func _on_invincibility_timer_timeout():
	invulnerable = false
	shield.visible = false
	sprite.modulate.a = 1.0

# Called when triple shot duration ends
func _on_triple_shot_timer_timeout():
	triple_shot = false
