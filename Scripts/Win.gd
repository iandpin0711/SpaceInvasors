extends Control

# Music to play on win screen
@onready var music = $WinMusic

# Called when player presses exit button
func _on_exit_pressed():
	# Stop the music
	music.stop()
	# Reset global values
	_reset_globals()
	# Go back to main menu
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")

# Reset global variables and signals
func _reset_globals():
	Signals.score = 0
	Signals.on_score_increment.emit(0)
