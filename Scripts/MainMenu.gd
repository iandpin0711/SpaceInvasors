extends Control

@onready var music = $MenuMusic
@onready var h_slider = $HSlider

func _ready():
	var linear_vol = db_to_linear(AudioServer.get_bus_volume_db(0))
	h_slider.value = linear_vol

func _on_texture_button_pressed():
	music.stop()
	get_tree().change_scene_to_file("res://Scene/MainScene.tscn")

func _on_h_slider_value_changed(value: float) -> void:
	var adjusted_value = clamp(value, 0.0001, 1.0)
	music.volume_db = linear_to_db(adjusted_value)
	AudioServer.set_bus_volume_db(0, linear_to_db(adjusted_value))
