extends CharacterBody2D

const SPEED = 50
const PUSH_FORCE = 50
@onready var sprite: AnimatedSprite2D =  $AnimatedSprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var tilemap: TileMapLayer = $"../TileMapLayer"
@onready var timer: Timer = $Timer

enum MOVE_DIRECTION {front, right, back, left}
var direction = MOVE_DIRECTION.front
var inviolable = false
var hp = 4
var additional_velocity = 0
var additional_push_vector = Vector2(0, 0)
const BULLET_PUSH_FORCE = 150

func _physics_process(_delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if !inviolable:
		if(input_direction[0] > 0):
			sprite.play("walk_right")
			direction = MOVE_DIRECTION.right
		if(input_direction[0] < 0):
			sprite.play("walk_left")
			direction = MOVE_DIRECTION.left
		if(input_direction[1] < 0):
			sprite.play("walk_up")
			direction = MOVE_DIRECTION.front
		if(input_direction[1] > 0):
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
	if direction == MOVE_DIRECTION.left:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	velocity = input_direction * SPEED + additional_velocity * additional_push_vector
	apply_floor_snap()
	move_and_slide()
	velocity -= additional_velocity * additional_push_vector
	additional_velocity -= 2
	if additional_velocity < 0:
		additional_velocity = 0
	
	for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var body = collision.get_collider()
			if body is RigidBody2D:
				var layer = body.collision_layer
				if layer & (1 << 0):
					collision.get_collider().apply_central_impulse(
						-collision.get_normal() * PUSH_FORCE
					)
				elif layer & (1 << 4):
					if !inviolable:
						hp-=1
						inviolable=true
						sprite.play("invul")
						timer.start()
					var bullet_id = collision.get_collider_id()
					instance_from_id(bullet_id). queue_free()
				elif layer & (1 << 3):
					if !inviolable:
						additional_push_vector = body.linear_velocity.normalized()
						additional_velocity = BULLET_PUSH_FORCE
					var bullet_id = collision.get_collider_id()
					instance_from_id(bullet_id). queue_free()
				elif layer & (1 << 4):
					if hp<4:
						hp+=1
					var heart = collision.get_collider_id()
					instance_from_id(heart).queue_free()
					%Manager.is_heart = false



func _process(_delta):
	$Label2.text = "Hp: " + str(hp)
	var global_pos = Vector2i(global_position[0],global_position[1]+11)
	var local_pos = tilemap.to_local(global_pos)
	var tile_coords = tilemap.local_to_map(local_pos)

	var source_id = tilemap.get_cell_source_id(tile_coords)
	var atlas_coords = tilemap.get_cell_atlas_coords(tile_coords)
	if !inviolable:
		if source_id != -1:
			if atlas_coords==Vector2i(2,2):
				print("spadles")
				hp-=1
				inviolable=true
				sprite.play("invul")
				timer.start()
		else:
			print("spadles")
			hp-=1
			inviolable=true
			sprite.play("invul")
			timer.start()
	if hp<=0:
		hp=4
		print("umarłeś")
		die()
		
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
		
		if source_id != -1:
			tilemap.set_cell(Vector2i(tile_coords),0,Vector2i(2,2))
		else:
			print("Strzał poza mapę")
		
	if event.is_action_pressed("bomb") and $ProgressBar2.full:
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
			tilemap.set_cell(Vector2i(tile_coords),0,Vector2i(2,2))
		else:
			print("Strzał poza mapę")
			return
		$ProgressBar2.start()
		if source_id1 != -1:
			tilemap.set_cell(Vector2i(tile_coords[0]+1,tile_coords[1]),0,Vector2i(2,2))
		if source_id2 != -1:
			tilemap.set_cell(Vector2i(tile_coords[0]-1,tile_coords[1]),0,Vector2i(2,2))
		if source_id3 != -1:
			tilemap.set_cell(Vector2i(tile_coords[0],tile_coords[1]+1),0,Vector2i(2,2))
		if source_id4 != -1:
			tilemap.set_cell(Vector2i(tile_coords[0],tile_coords[1]-1),0,Vector2i(2,2))
	if event.is_action_pressed("restore") and $ProgressBar.full:
		$ProgressBar.start()
		tilemap.restore()

func _ready():
	EnemiesManager.label = $Label
	timer.start()

func _on_timer_timeout() -> void:
	timer.stop()
	inviolable = false

func die():
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
