extends Node2D

@onready var exit_button = $Exit
@onready var tutorial_button = $Tutorial
@onready var start_button = $Start


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes//game.tscn")

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes//tutorial.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
