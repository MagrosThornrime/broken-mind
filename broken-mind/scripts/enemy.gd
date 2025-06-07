extends RigidBody2D

var score_manager: Node
var tilemap: TileMapLayer
@onready var timer: Timer = $Timer
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

func _process(_delta):
	var global_pos = Vector2i(global_position[0],global_position[1]+11)
	var local_pos = tilemap.to_local(global_pos)
	var tile_coords = tilemap.local_to_map(local_pos)

	var source_id = tilemap.get_cell_source_id(tile_coords)
	var atlas_coords = tilemap.get_cell_atlas_coords(tile_coords)
	
	if source_id != -1:
		if atlas_coords==Vector2i(0,19):
			score_manager.add_point()
			queue_free()
	else:
		score_manager.add_point()
		queue_free()

func _ready():
	timer.start(3)

func _on_timer_timeout() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	get_tree().current_scene.add_child(bullet)
