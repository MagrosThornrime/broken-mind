extends TileMapLayer

func restore():
	var used_rect = get_used_rect()
	for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
		for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
			var coords = Vector2i(x, y)
			set_cell(coords, 0, Vector2i(1, 9))
