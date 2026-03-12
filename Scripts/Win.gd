extends Control

@onready var music = $WinMusic

func _on_exit_pressed():
	music.stop()
	_reset_globals()
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")

func _reset_globals():
	Signals.score = 0
	Signals.on_score_increment.emit(0)
