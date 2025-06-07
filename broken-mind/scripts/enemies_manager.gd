extends Node

var label: Label
var points = 0
var manager: Node

func add_point():
	points += 1
	print(points)
	label.text="Score: "+str(points)
	manager.en_nr-=1
