extends HBoxContainer

@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer
var full
const max_time = 10

func _ready() -> void:
	timer.start(max_time)

func _physics_process(_delta: float) -> void:
	var progress = (max_time - timer.time_left) / max_time * 100
	bar.set_value(progress)
	
	if abs(progress - 100.0) < 0.00001:
		full=true
func start():
	full=false
	timer.start()
