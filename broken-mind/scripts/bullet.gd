extends RigidBody2D

@export var speed := 30.0
var target_position: Vector2

func _ready():
	var direction = (target_position - global_position).normalized()
	linear_velocity = direction * speed
	#TODO:
	#Po przeleceniu pewnego dystansu pocisk usuwa się ze sceny
	pass

#TODO:
#Kolizja pocisku i gracza
