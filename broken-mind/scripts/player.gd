extends Node2D

const SPEED = 50
@onready var sprite: AnimatedSprite2D =  $AnimatedSprite2D
@onready var body: CharacterBody2D = $CharacterBody2D
@onready var shape: CollisionShape2D = $CharacterBody2D/CollisionShape2D
@onready var tilemap: TileMapLayer = $"../TileMapLayer"

enum MOVE_DIRECTION {front, right, back, left}
var direction = MOVE_DIRECTION.front

func _physics_process(_delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(input_direction[0] > 0 and body.velocity != Vector2.ZERO):
		sprite.play("walk_right")
		direction = MOVE_DIRECTION.right
	if(input_direction[0] < 0 and body.velocity != Vector2.ZERO):
		sprite.play("walk_left")
		direction = MOVE_DIRECTION.left
	if(input_direction[1] < 0 and body.velocity != Vector2.ZERO):
		sprite.play("walk_up")
		direction = MOVE_DIRECTION.front
	if(input_direction[1] > 0 and body.velocity != Vector2.ZERO):
		sprite.play("walk_down")
		direction = MOVE_DIRECTION.back
	if body.velocity == Vector2.ZERO:
		match direction:
			MOVE_DIRECTION.right:
				sprite.play("idle_right")
			MOVE_DIRECTION.left:
				sprite.play("idle_left")
			MOVE_DIRECTION.front:
				sprite.play("idle_front")
			MOVE_DIRECTION.back:
				sprite.play("idle_back")
	body.velocity = input_direction * SPEED
	body.apply_floor_snap()
	body.move_and_slide()
	global_position = body.global_position
	body.position = Vector2.ZERO


func _process(_delta):
	var global_pos = Vector2i(global_position[0],global_position[1]+11)
	var local_pos = tilemap.to_local(global_pos)
	var tile_coords = tilemap.local_to_map(local_pos)

	var atlas_coords = tilemap.get_cell_atlas_coords(tile_coords)

	#if source_id != -1:
		#print("Stoję na kafelku:")
		#print("Atlas coords: ", atlas_coords)
	#else:
		#print("Brak kafelka pod obiektem")
