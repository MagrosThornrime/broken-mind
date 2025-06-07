extends Node

@onready var tilemap: TileMapLayer = $"../TileMapLayer"
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

func get_all_valid_tiles() -> Array:
	var valid_tiles = []

	for x in range(tilemap.get_used_rect().position.x, tilemap.get_used_rect().end.x):
		for y in range(tilemap.get_used_rect().position.y, tilemap.get_used_rect().end.y):
			var pos = Vector2i(x, y)
			var source_id = tilemap.get_cell_source_id(pos)

			if source_id != -1:
				var atlas_coords = tilemap.get_cell_atlas_coords(pos)
				if atlas_coords != Vector2i(0, 19):
					valid_tiles.append(pos)

	return valid_tiles

func spawn_enemy(tiles: Array):
	if tiles.is_empty():
		print("Brak dostępnych kafelków do spawnu!")
		return

	var index = randi() % tiles.size()
	var tile_pos = tiles[index]
	tiles.remove_at(index)

	var world_pos = tilemap.map_to_local(tile_pos) + tilemap.position
	var enemy = enemy_scene.instantiate()
	enemy.score_manager = $"../ScoreManager"
	enemy.tilemap = tilemap
	enemy.global_position = Vector2i(world_pos[0],world_pos[1]-6)
	add_child(enemy)

func spawn_multiple_enemies(count: int):
	var tiles = get_all_valid_tiles()
	
	for i in range(count):
		if tiles.is_empty():
			print("Zabrakło miejsc!")
			break
		spawn_enemy(tiles)

func _ready():
	spawn_multiple_enemies(3)
