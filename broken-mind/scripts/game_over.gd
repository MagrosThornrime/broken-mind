extends Node2D

@onready var score_label = $ScoreLabel

func _ready() -> void:
	score_label.text = "Score: " + str(EnemiesManager.points)


func _on_start_pressed() -> void:
	EnemiesManager.points = 0
	Music.stop()
	Music.stream = load("res://audio/Battle of the Void.mp3")
	Music.play()
	get_tree().change_scene_to_file("res://scenes//game.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
