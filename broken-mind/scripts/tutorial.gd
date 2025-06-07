extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("klik"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
