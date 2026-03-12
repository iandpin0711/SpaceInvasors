extends Control

@onready var music = $GameOverMusic

func _on_restart_pressed() -> void:
	music.stop()
	get_tree().change_scene_to_file("res://Scene/MainScene.tscn")

func _on_exit_pressed() -> void:
	music.stop()
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
