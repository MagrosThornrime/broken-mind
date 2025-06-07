extends TileMapLayer
@onready var timer: Timer = $Timer

func restore():
	var used_rect = get_used_rect()
	for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
		for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
			var coords = Vector2i(x, y)
			set_cell(coords, 0, Vector2i(8, 1))

func void_tiles(n):
	var used_rect = get_used_rect()
	var all_coords = []

	for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
		for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
			var pos = Vector2i(x, y)
			var source_id = get_cell_source_id(pos)
			if source_id != -1:
				var atlas_coords = get_cell_atlas_coords(pos)
				if atlas_coords != Vector2i(2, 2):
					var player_pos = Vector2i($"../Player".global_position[0],$"../Player".global_position[1]+11)
					var local_pos = to_local(player_pos)
					var tile_coords = local_to_map(local_pos)
					if pos != tile_coords:
						all_coords.append(pos)
	
	all_coords.shuffle()
	var player_coords = local_to_map(to_local($"../Player".global_position))
	for i in range(min(n, all_coords.size())):
		set_cell(all_coords[i], 0, Vector2i(2, 2))
	
func _ready():
	timer.start(4)
	

func _on_timer_timeout() -> void:
	void_tiles(3)
