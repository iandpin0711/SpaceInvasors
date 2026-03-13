extends Node2D

# Enemy scenes to spawn
var pEnemies = [
	preload("res://Assets/NormalEnemy.tscn"),
	preload("res://Assets/ShieldEnemy.tscn"),
	preload("res://Assets/SpeedEnemy.tscn")
]

# Asteroid scene
var pAsteroid = preload("res://Assets/Asteroid.tscn")

# Power-up scenes to spawn
var pPowerups = [
	preload("res://Assets/ShieldPowerup.tscn"),
	preload("res://Assets/AttackPowerup.tscn"),
	preload("res://Assets/HealthPowerup.tscn")
]

# Timers for spawning enemies and power-ups
@onready var spawnTimer = %SpawnTimer
@onready var powerupSpawnTimer = %PowerSpawnTimer

# Time between enemy spawns
var nextSpawnTime = 2.5
# Min and max time between power-up spawns
var minPowerupSpawnTime = 5
var maxPowerupSpawnTime = 35

# Called when the scene starts
func _ready():
	randomize()
	# Start enemy spawn timer
	spawnTimer.start(2)
	# Start power-up spawn timer with random duration
	powerupSpawnTimer.start(randf_range(minPowerupSpawnTime, maxPowerupSpawnTime))
	
	# Listen for boss start signal to stop spawns
	Signals.boss_start.connect(_on_boss_start)

# Get a random position along the top of the screen
func getRandomSpawnPos() -> Vector2:
	var viewReact = get_viewport_rect()
	var xPos = randf_range(viewReact.position.x, viewReact.end.x)
	return Vector2(xPos, position.y)

# Called when enemy spawn timer finishes
func _on_spawn_timer_timeout():
	var r = randf()
	var enemy_scene
	
	# Decide which enemy to spawn
	if r < 0.5:
		enemy_scene = pEnemies[0]
	elif r < 0.8:
		enemy_scene = pEnemies[1]
	elif r < 1.0:
		enemy_scene = pEnemies[2]
		
	# Small chance to spawn an asteroid instead
	if randf() < 0.1:
		enemy_scene = pAsteroid
	
	if enemy_scene:
		# Spawn enemy at random position
		var enemy = enemy_scene.instantiate()
		enemy.position = getRandomSpawnPos()
		get_tree().current_scene.add_child(enemy)
	
	# Restart enemy spawn timer
	spawnTimer.start(nextSpawnTime)

# Called when power-up spawn timer finishes
func _on_power_spawn_timer_timeout():
	# Pick random power-up
	var pPowerup = pPowerups[randi() % pPowerups.size()]
	var powerup = pPowerup.instantiate()
	# Spawn at random position
	powerup.position = getRandomSpawnPos()
	get_tree().current_scene.add_child(powerup)
	# Restart timer with random duration
	powerupSpawnTimer.start(randf_range(minPowerupSpawnTime, maxPowerupSpawnTime))

# Called when boss fight starts
func _on_boss_start():
	# Stop enemy spawns
	spawnTimer.stop()
