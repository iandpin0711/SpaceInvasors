extends Control

@onready var music = $WinMusic

func _on_exit_pressed():
	music.stop()
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
