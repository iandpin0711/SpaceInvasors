extends Control

# Life icon scene
var pLifeIcon = preload("res://Assets/LifeIcon.tscn")
# Container for life icons
@onready var lifeContainer = %LifeContainer
# Label to display the score
@onready var scoreLabel = $Score

# Current score
var score = 0

# Called when the node enters the scene
func _ready():
	# Remove all life icons at start
	clearLives()
	# Connect signals to update UI when lives or score change
	Signals.on_player_life_changed.connect(_on_player_life_changed)
	Signals.on_score_increment.connect(_on_score_increment)

# Remove all life icons from the container
func clearLives():
	for child in lifeContainer.get_children():
		lifeContainer.remove_child(child)
		child.queue_free()

# Update the life icons to match current lives
func setLives(lives):
	clearLives()
	for i in range(lives):
		lifeContainer.add_child(pLifeIcon.instantiate())

# Called when the player's lives change
func _on_player_life_changed(life):
	setLives(life)

# Called when the score changes
func _on_score_increment(amount):
	score += amount
	scoreLabel.text = str(score)
