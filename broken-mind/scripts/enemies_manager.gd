extends Node

@onready var label: Label = $"../Player/Label"
@onready var points = 0
	
func add_point():
	points += 1
	print(points)
	label.text="Score: "+str(points)
