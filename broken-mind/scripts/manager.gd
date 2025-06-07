extends Node

@onready var tilemap: TileMapLayer = $"../TileMapLayer"
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var heart_scene: PackedScene = preload("res://scenes/heart.tscn")
var tura = 0
var en_nr = 0
@onready var timer: Timer = $Timer
var is_heart = false

func get_all_valid_tiles() -> Array:
	var valid_tiles = []

	for x in range(tilemap.get_used_rect().position.x, tilemap.get_used_rect().end.x):
		for y in range(tilemap.get_used_rect().position.y, tilemap.get_used_rect().end.y):
			var pos = Vector2i(x, y)
			var source_id = tilemap.get_cell_source_id(pos)

			if source_id != -1:
				var atlas_coords = tilemap.get_cell_atlas_coords(pos)
				if atlas_coords != Vector2i(2, 2):
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
	enemy.tilemap = tilemap
	enemy.player = $"../Player"
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
	tura=0
	spawn_multiple_enemies(2)
	en_nr+=2
	timer.start(15)
	
func _process(_delta):
	EnemiesManager.manager = %Manager
	if en_nr==0:
		tura=min(16,tura+1)
		spawn_multiple_enemies(2+int(tura/2))
		en_nr+=2+int(tura/2)

func spawn_heart():
	var tiles = get_all_valid_tiles()
	if tiles.is_empty():
		print("Brak dostępnych kafelków do spawnu!")
		return

	var index = randi() % tiles.size()
	var tile_pos = tiles[index]
	tiles.remove_at(index)

	var world_pos = tilemap.map_to_local(tile_pos) + tilemap.position
	var heart = heart_scene.instantiate()
	heart.global_position = Vector2i(world_pos[0],world_pos[1]-6)
	add_child(heart)


func _on_timer_timeout() -> void:
	if !is_heart:
		spawn_heart()
		is_heart=true
