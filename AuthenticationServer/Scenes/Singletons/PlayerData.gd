extends Node


var data

func _ready():
	
	var data_file = File.new()
	data_file.open("res://Data/player_data.json", File.READ)
	
	var text_data = data_file.get_as_text()
	var json_data = JSON.parse(text_data)
	
	data_file.close()
	data = json_data.result


func save_player_data():
	
	var save_file = File.new()
	save_file.open("res://Data/player_data.json", File.WRITE)
	save_file.store_line(to_json(data))
	save_file.close() 
