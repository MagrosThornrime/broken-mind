extends Node2D

@onready var exit_button = $Exit
@onready var tutorial_button = $Tutorial
@onready var start_button = $Start

func _ready() -> void:
	Music.stream = load("res://audio/claimed_by_the_void.mp3")
	Music.play()

func _on_start_pressed() -> void:
	Music.stop()
	Music.volume_db -= 3
	Music.stream = load("res://audio/Battle of the Void.mp3")
	Music.play()
	ButtonSound.play()
	get_tree().change_scene_to_file("res://scenes//game.tscn")

func _on_tutorial_pressed() -> void:
	ButtonSound.play()
	get_tree().change_scene_to_file("res://scenes//tutorial.tscn")

func _on_exit_pressed() -> void:
	ButtonSound.play()
	get_tree().quit()
