extends Node

var player_name: String
var player_list = []

func _ready():
	SilentWolf.configure({
		"api_key": "WEZUoyl7sW5itLgUH3C0M3FpD8wxgDglaHq2p6rH",
		"game_id": "brokenmind",
		"log_level": 1
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tson"
	})

func _physics_process(delta: float) -> void:
	leaderboard()

func leaderboard():
	for score in Global.score:
		Global.player_list.append(Global.player_name)
