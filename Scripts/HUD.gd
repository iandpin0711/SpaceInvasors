extends Control

var pLifeIcon = preload("res://Assets/LifeIcon.tscn")
@onready var lifeContainer = %LifeContainer
@onready var scoreLabel = $Score

var score = 0

func _ready():
	clearLives()
	
	Signals.on_player_life_changed.connect(_on_player_life_changed)
	Signals.on_score_increment.connect(_on_score_increment)

func clearLives():
	for child in lifeContainer.get_children():
		lifeContainer.remove_child(child)
		child.queue_free()

func setLives(lives):
	clearLives()
	for i in range(lives):
		lifeContainer.add_child(pLifeIcon.instantiate())

func _on_player_life_changed(life):
	setLives(life)

func _on_score_increment(amount):
	score += amount
	scoreLabel.text = str(score)
