extends Node2D

@onready var score_label = $ScoreLabel

func _ready() -> void:
	score_label.text = "Score: " + str(EnemiesManager.points)
