extends CharacterBody2D

# Vertical speed of the boss
const VERTICAL_SPEED = 100.0
# Max distance the boss moves down before stopping
const RANGE = 1200

# Tracks how far the boss has moved
var travelled_distance = 0
var health = 200
var dying = false
var active = false
# Y position where the boss stops descending
var stop_y = 200
var boss_started = false
var attack_in_progress = false

# Attack timing
var attack_cooldown_min = 3.0
var attack_cooldown_max = 5.0
var initial_wait = 3.0

# Horizontal movement
var horizontal_speed = 100.0
var horizontal_dir = 1
var side_margin = 120

# Nodes
@onready var shoot_sound = $ShootSound
@onready var boss_timer = $BossStartTimer
@onready var bullet_pos = $BulletPosition
@onready var laser1_pos = $Laser1Position
@onready var laser2_pos = $Laser2Position
@onready var player = get_tree().current_scene.get_node_or_null("Player")

# Setup connections and animations
func _ready():
	Signals.on_score_increment.connect(_on_score_increment)
	visible = false
	$IdleEffect.play("effect")
	$Sprite2D.play("idle")

# Movement and position update
func _physics_process(delta):
	if not active:
		return

	# Move down until stop_y
	if position.y < stop_y:
		position.y += VERTICAL_SPEED * delta
		if position.y >= stop_y:
			position.y = stop_y
	else:
		# Move left/right
		position.x += horizontal_speed * horizontal_dir * delta
		var view_rect = get_viewport_rect()
		if position.x < side_margin:
			position.x = side_margin
			horizontal_dir = 1
		elif position.x > view_rect.size.x - side_margin:
			position.x = view_rect.size.x - side_margin
			horizontal_dir = -1

# Start boss when score reaches threshold
func _on_score_increment(amount):
	if Signals.score >= 300 and not boss_started:
		boss_started = true
		var spawner = get_tree().current_scene.get_node_or_null("Spawner")
		if spawner and spawner.spawnTimer:
			spawner.spawnTimer.stop()
		boss_timer.start()

# Called when boss timer finishes
func _on_boss_start_timer_timeout():
	visible = true
	active = true
	position = Vector2(get_viewport_rect().size.x / 2, -200)
	yield_to_stop_y()

# Wait until boss reaches stop_y, then pause before attacking
func yield_to_stop_y() -> void:
	while position.y < stop_y:
		if not is_inside_tree():
			return
		await get_tree().process_frame

	position.y = stop_y
	await get_tree().create_timer(initial_wait).timeout

	if not attack_in_progress:
		attack_in_progress = true
		start_attack_routine()

# Main attack loop
func start_attack_routine():
	while not dying:
		if not is_inside_tree():
			return

		# Randomly choose attack type
		if randi() % 2 == 0:
			await execute_bullet_attack()
		else:
			await execute_laser_attack()

		var cooldown_duration = randf_range(attack_cooldown_min, attack_cooldown_max)

		if not is_inside_tree():
			return

		await get_tree().create_timer(cooldown_duration).timeout

# Shoot bullets toward the player
func execute_bullet_attack() -> void:
	if dying:
		return
	
	var bullet_count = randi() % 4 + 3
	for i in range(bullet_count):
		shoot_sound.stop()
		shoot_sound.play()
		var bullet = preload("res://Assets/BossBullet.tscn").instantiate()
		bullet.global_position = bullet_pos.global_position

		if player:
			var dir = (player.global_position - bullet.global_position).normalized()
			bullet.rotation = dir.angle() + PI/2
			bullet.set("direction", dir)

		get_tree().current_scene.add_child(bullet)
		await get_tree().create_timer(1).timeout

# Fire lasers from both sides
func execute_laser_attack() -> void:
	if dying:
		return

	$Sprite2D.play("attack")

	# Wait until attack animation reaches frame 14
	while $Sprite2D.frame < 14 and not dying:
		if not is_inside_tree():
			return
		await get_tree().process_frame

	# Spawn lasers
	var laser1 = preload("res://Assets/BossLaser.tscn").instantiate()
	laser1.position = laser1_pos.position
	laser1.z_index = $Sprite2D.z_index - 1
	add_child(laser1)

	var laser2 = preload("res://Assets/BossLaser.tscn").instantiate()
	laser2.position = laser2_pos.position
	laser2.z_index = $Sprite2D.z_index - 1
	add_child(laser2)

	# Wait until animation ends
	while $Sprite2D.frame < 55 and not dying:
		if not is_inside_tree():
			return
		await get_tree().process_frame

	# Remove lasers
	if is_instance_valid(laser1):
		laser1.queue_free()
	if is_instance_valid(laser2):
		laser2.queue_free()

# Handle damage taken
func take_damage():
	if dying:
		return

	health -= 1
	if health <= 0:
		dying = true
		active = false
		attack_in_progress = false
		$CollisionShape2D.set_deferred("disabled", true)
		$IdleEffect.visible = false
		$Sprite2D.play("die")

# When death animation finishes
func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "die":
		get_tree().change_scene_to_file("res://Scene/Win.tscn")
