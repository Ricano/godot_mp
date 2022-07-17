extends Control

onready var level = $NinePatchRect/VBoxContainer/Level/Value


# Called when the node enters the scene tree for the first time.
func _ready():
	Server.request_player_stats_from_server()
	yield(get_tree().create_timer(3), "timeout")
	get_parent().get_node("/root/SceneHandler").switch_to("stage_1")

func load_player_stats(stats):
	print("Loading Player Stats")
	level.set_text(str(stats.level))
	print("Player Stats: " + str(stats.level))
	
