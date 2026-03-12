extends Control

# Reference to the game over music
@onready var music = $GameOverMusic

# Called when the restart button is pressed
func _on_restart_pressed():
	# Stop the music
	music.stop()
	# Reset global variables
	_reset_globals()
	# Go back to the main game scene
	get_tree().change_scene_to_file("res://Scene/MainScene.tscn")

# Called when the exit button is pressed
func _on_exit_pressed():
	# Stop the music
	music.stop()
	# Reset global variables
	_reset_globals()
	# Go to the main menu scene
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")

# Reset global score values
func _reset_globals():
	Signals.score = 0
	Signals.on_score_increment.emit(0)
