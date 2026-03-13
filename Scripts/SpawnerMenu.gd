extends Node2D

# Enemy scenes to spawn
var pEnemies = [
	preload("res://Assets/NormalEnemy.tscn"),
	preload("res://Assets/ShieldEnemy.tscn"),
	preload("res://Assets/SpeedEnemy.tscn")
]

# Timer for spawning enemies
@onready var spawnTimer = %SpawnTimer
# Time between spawns
var nextSpawnTime = 2

# Called when scene starts
func _ready():
	randomize()
	# Start the spawn timer
	spawnTimer.start(2)

# Get a random position along the top of the screen
func getRandomSpawnPos() -> Vector2:
	var viewReact = get_viewport_rect()
	var xPos = randf_range(viewReact.position.x, viewReact.end.x)
	return Vector2(xPos, position.y)

# Called when spawn timer finishes
func _on_spawn_timer_timeout():
	var r = randf()
	var enemy_scene
	
	# Decide which enemy to spawn based on random value
	if r < 0.5:
		enemy_scene = pEnemies[0]
	elif r < 0.8:
		enemy_scene = pEnemies[1]
	elif r < 1.0:
		enemy_scene = pEnemies[2]
	
	if enemy_scene:
		# Spawn enemy at random position
		var enemy = enemy_scene.instantiate()
		enemy.position = getRandomSpawnPos()
		get_tree().current_scene.add_child(enemy)
	
	# Restart spawn timer
	spawnTimer.start(nextSpawnTime)
