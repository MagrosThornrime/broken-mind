extends Node2D

func _on_return_pressed() -> void:
	ButtonSound.play()
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
