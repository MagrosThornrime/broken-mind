extends RigidBody2D

@export var speed := 50.0
var target_position: Vector2

func _ready():
	var direction = (target_position - global_position).normalized()
	rotation = direction.angle()
	linear_velocity = direction * speed

	await get_tree().create_timer(6).timeout
	queue_free()
