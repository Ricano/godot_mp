extends Node

var stage_1 = preload("res://Scenes/Main/Stages/Stage1.tscn")
var login = preload("res://Scenes/Main/LoginScreen.tscn")
var stats = preload("res://Scenes/Main/PlayerStats.tscn")

var scenes_dict = {
	"stage_1" : stage_1,
	"login" : login,
	"stats" : stats
	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_login = login.instance()
	add_child(new_login)
	
func switch_to(scene):
	var new_scene = scenes_dict[scene].instance()
	add_child(new_scene)
