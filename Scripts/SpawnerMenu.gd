extends Node2D

var pEnemies = [
	preload("res://Assets/NormalEnemy.tscn"),
	preload("res://Assets/ShieldEnemy.tscn"),
	preload("res://Assets/SpeedEnemy.tscn")
]

@onready var spawnTimer = %SpawnTimer
var nextSpawnTime = 2

func _ready():
	randomize()
	spawnTimer.start(2)

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
	
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = getRandomSpawnPos()
		get_tree().current_scene.add_child(enemy)
	
	spawnTimer.start(nextSpawnTime)
