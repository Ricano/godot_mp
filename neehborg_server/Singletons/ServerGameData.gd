extends Node


var data


var test_data = {
	"level": 20
	}

func _ready():
	
	var data_file = File.new()
	data_file.open("res://Data/skill_data.json", File.READ)
	
	var text_data = data_file.get_as_text()
	var json_data = JSON.parse(text_data)
	
	data_file.close()
	data = json_data.result

