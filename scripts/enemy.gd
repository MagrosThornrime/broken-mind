extends RigidBody2D

var player
var tilemap: TileMapLayer
@onready var timer: Timer = $Timer
var damaging_bullet: PackedScene = preload("res://scenes/damaging_bullet.tscn")
var pushing_bullet: PackedScene = preload("res://scenes/pushing_bullet.tscn")

enum BULLET_TYPE {damaging, pushing}

func _process(_delta):
	var global_pos = Vector2i(global_position[0],global_position[1]+11)
	var local_pos = tilemap.to_local(global_pos)
	var tile_coords = tilemap.local_to_map(local_pos)

	var source_id = tilemap.get_cell_source_id(tile_coords)
	var atlas_coords = tilemap.get_cell_atlas_coords(tile_coords)
	
	if source_id != -1:
		if atlas_coords==Vector2i(2,2):
			EnemiesManager.add_point()
			queue_free()
	else:
		EnemiesManager.add_point()
		queue_free()

func _ready():
	var random_time = randf_range(2.0, 4.0)
	timer.start(random_time)

func _on_timer_timeout() -> void:
	var bullet = null
	if randi_range(0, 9) > 3:
		bullet = damaging_bullet.instantiate()
	else:
		bullet = pushing_bullet.instantiate()
	bullet.global_position = global_position
	bullet.target_position = player.global_position
	get_tree().current_scene.add_child(bullet)
