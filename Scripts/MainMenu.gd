extends Control

# Menu music
@onready var music = $MenuMusic
# Volume slider
@onready var h_slider = $HSlider

# Called when the menu scene starts
func _ready():
	# Get current audio volume and convert it to linear value
	var linear_vol = db_to_linear(AudioServer.get_bus_volume_db(0))
	# Set slider to match current volume
	h_slider.value = linear_vol

# Change music volume with slider
func _on_h_slider_value_changed(value: float) -> void:
	# Clamp value to avoid zero or invalid values
	var adjusted_value = clamp(value, 0.0001, 1.0)

	# Apply volume to menu music
	music.volume_db = linear_to_db(adjusted_value)

	# Apply volume to the main audio bus
	AudioServer.set_bus_volume_db(0, linear_to_db(adjusted_value))

# Start game when button is pressed
func _on_play_button_pressed():
	# Stop menu music
	music.stop()
	# Load the main game scene
	get_tree().change_scene_to_file("res://Scene/MainScene.tscn")
