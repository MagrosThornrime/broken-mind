extends Node2D

@onready var score_label = $ScoreLabel
var player_name = ""

func _ready() -> void:
	score_label.text = "Score: " + str(EnemiesManager.points)
	Global.score = EnemiesManager.points


func _on_start_pressed() -> void:
	EnemiesManager.points = 0
	Music.stop()
	Music.volume_db -= 3
	Music.stream = load("res://audio/Battle of the Void.mp3")
	Music.play()
	ButtonSound.play()
	get_tree().change_scene_to_file("res://scenes//game.tscn")


func _on_exit_pressed() -> void:
	ButtonSound.play()
	Music.stop()
	Music.stream = load("res://audio/claimed_by_the_void.mp3")
	Music.play()
	get_tree().change_scene_to_file("res://scenes//start_menu.tscn")


func _on_submit_pressed() -> void:
	ButtonSound.play()
	player_name = $LineEdit.text
	if player_name!="":
		Global.player_name=player_name
		var sw_result : Dictionary = await SilentWolf.Scores.save_score(Global.player_name, Global.score).sw_save_score_complete
		Music.stop()
		Music.stream = load("res://audio/claimed_by_the_void.mp3")
		Music.play()
		get_tree().change_scene_to_file("res://scenes//start_menu.tscn")
