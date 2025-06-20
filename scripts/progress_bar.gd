extends HBoxContainer

@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer
var full
@export var max_time = 60

func _ready() -> void:
	timer.start(max_time)

func _physics_process(_delta: float) -> void:
	var progress = (max_time - timer.time_left) / max_time * 100
	bar.set_value(progress)
	
	if abs(progress - 100.0) < 0.00001:
		bar.texture_progress = load("res://textures/green_bar.tres")
		full=true
		
func start():
	bar.texture_progress = load("res://textures/red_bar.tres")	
	full=false
	timer.start()
