extends Node2D

var pEnemies = [
	preload("res://Assets/NormalEnemy.tscn"),
	preload("res://Assets/ShieldEnemy.tscn"),
	preload("res://Assets/SpeedEnemy.tscn")
]

var pAsteroid = preload("res://Assets/Asteroid.tscn")

var pPowerups = [
	preload("res://Assets/ShieldPowerup.tscn"),
	preload("res://Assets/AttackPowerup.tscn"),
	preload("res://Assets/HealthPowerup.tscn")
]

@onready var spawnTimer = %SpawnTimer
@onready var powerupSpawnTimer = %PowerSpawnTimer
var nextSpawnTime = 2.5
var minPowerupSpawnTime = 5
var maxPowerupSpawnTime = 35

func _ready():
	randomize()
	spawnTimer.start(2)
	powerupSpawnTimer.start(randf_range(minPowerupSpawnTime, maxPowerupSpawnTime))
	
	# cambio mínimo: escuchar señal boss_start
	Signals.boss_start.connect(_on_boss_start)


func getRandomSpawnPos() -> Vector2:
	var viewReact = get_viewport_rect()
	var xPos = randf_range(viewReact.position.x, viewReact.end.x)
	return Vector2(xPos, position.y)


func _on_spawn_timer_timeout():
	var r = randf()
	var enemy_scene
	
	if r < 0.5:
		enemy_scene = pEnemies[0]
	elif r < 0.8:
		enemy_scene = pEnemies[1]
	elif r < 1.0:
		enemy_scene = pEnemies[2]
		
	if randf() < 0.1:
		enemy_scene = pAsteroid
	
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = getRandomSpawnPos()
		get_tree().current_scene.add_child(enemy)
	
	spawnTimer.start(nextSpawnTime)


func _on_power_spawn_timer_timeout():
	var pPowerup = pPowerups[randi() % pPowerups.size()]
	var powerup = pPowerup.instantiate()
	powerup.position = getRandomSpawnPos()
	get_tree().current_scene.add_child(powerup)
	powerupSpawnTimer.start(randf_range(minPowerupSpawnTime, maxPowerupSpawnTime))


func _on_boss_start():
	spawnTimer.stop()
