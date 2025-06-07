extends Node

@onready var points = 0
var label
var manager

func add_point():
	points += 1
	print(points)
	label.text="Score: "+str(points)
	if points%3==0:
		manager.spawn_multiple_enemies(3)
