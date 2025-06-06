extends CharacterBody2D

const SPEED = 50
const PUSH_FORCE = 50
@onready var sprite: AnimatedSprite2D =  $AnimatedSprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var tilemap: TileMapLayer = $"../TileMapLayer"

enum MOVE_DIRECTION {front, right, back, left}
var direction = MOVE_DIRECTION.front

func _physics_process(_delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(input_direction[0] > 0 and velocity != Vector2.ZERO):
		sprite.play("walk_right")
		direction = MOVE_DIRECTION.right
	if(input_direction[0] < 0 and velocity != Vector2.ZERO):
		sprite.play("walk_left")
		direction = MOVE_DIRECTION.left
	if(input_direction[1] < 0 and velocity != Vector2.ZERO):
		sprite.play("walk_up")
		direction = MOVE_DIRECTION.front
	if(input_direction[1] > 0 and velocity != Vector2.ZERO):
		sprite.play("walk_down")
		direction = MOVE_DIRECTION.back
	if velocity == Vector2.ZERO:
		match direction:
			MOVE_DIRECTION.right:
				sprite.play("idle_right")
			MOVE_DIRECTION.left:
				sprite.play("idle_left")
			MOVE_DIRECTION.front:
				sprite.play("idle_front")
			MOVE_DIRECTION.back:
				sprite.play("idle_back")
	velocity = input_direction * SPEED
	apply_floor_snap()
	move_and_slide()
	
	for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_central_impulse(
					-collision.get_normal() * PUSH_FORCE
				)


func _process(_delta):
	var global_pos = Vector2i(global_position[0],global_position[1]+11)
	var local_pos = tilemap.to_local(global_pos)
	var tile_coords = tilemap.local_to_map(local_pos)

	var source_id = tilemap.get_cell_source_id(tile_coords)
	var atlas_coords = tilemap.get_cell_atlas_coords(tile_coords)

	#if source_id != -1:
		#print("Stoję na kafelku:")
		#print("Source ID: ", source_id)
		#print("Atlas coords: ", atlas_coords)
	#else:
		#print("Brak kafelka pod obiektem")
		
func _unhandled_input(event):
	if event.is_action_pressed("fire"):
		var fire_pos
		if direction == MOVE_DIRECTION.right:
			fire_pos = Vector2i(global_position[0]+40,global_position[1]+8)
		elif direction == MOVE_DIRECTION.left:
			fire_pos = Vector2i(global_position[0]-40,global_position[1]+8)
		elif direction == MOVE_DIRECTION.back:
			fire_pos = Vector2i(global_position[0],global_position[1]+40)
		else:
			fire_pos = Vector2i(global_position[0],global_position[1]-30)
		var local_pos = tilemap.to_local(fire_pos)
		var tile_coords = tilemap.local_to_map(local_pos)
		var source_id = tilemap.get_cell_source_id(tile_coords)
		var atlas_coords = tilemap.get_cell_atlas_coords(tile_coords)
		
		if source_id != -1:
			tilemap.set_cell(Vector2i(tile_coords),0,Vector2i(0,19))
		else:
			print("Strzał poza mapę")
	if event.is_action_pressed("bomb"):
		var fire_pos
		if direction == MOVE_DIRECTION.right:
			fire_pos = Vector2i(global_position[0]+40,global_position[1]+8)
		elif direction == MOVE_DIRECTION.left:
			fire_pos = Vector2i(global_position[0]-40,global_position[1]+8)
		elif direction == MOVE_DIRECTION.back:
			fire_pos = Vector2i(global_position[0],global_position[1]+40)
		else:
			fire_pos = Vector2i(global_position[0],global_position[1]-30)
		var local_pos = tilemap.to_local(fire_pos)
		var tile_coords = tilemap.local_to_map(local_pos)
		var source_id = tilemap.get_cell_source_id(tile_coords)
		var source_id1 = tilemap.get_cell_source_id(Vector2i(tile_coords[0]+1,tile_coords[1]))
		var source_id2 = tilemap.get_cell_source_id(Vector2i(tile_coords[0]-1,tile_coords[1]))
		var source_id3 = tilemap.get_cell_source_id(Vector2i(tile_coords[0],tile_coords[1]+1))
		var source_id4 = tilemap.get_cell_source_id(Vector2i(tile_coords[0],tile_coords[1]-1))
		
		if source_id != -1:
			tilemap.set_cell(Vector2i(tile_coords),0,Vector2i(0,19))
		else:
			print("Strzał poza mapę")
			return
		if source_id1 != -1:
			tilemap.set_cell(Vector2i(tile_coords[0]+1,tile_coords[1]),0,Vector2i(0,19))
		if source_id2 != -1:
			tilemap.set_cell(Vector2i(tile_coords[0]-1,tile_coords[1]),0,Vector2i(0,19))
		if source_id3 != -1:
			tilemap.set_cell(Vector2i(tile_coords[0],tile_coords[1]+1),0,Vector2i(0,19))
		if source_id4 != -1:
			tilemap.set_cell(Vector2i(tile_coords[0],tile_coords[1]-1),0,Vector2i(0,19))
