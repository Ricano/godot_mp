extends Node

var player_container_scene = preload("res://Scenes/Instances/PlayerContainer.tscn")

const TOKEN_EXPIRATION_TIME = 30

onready var main_interface = get_parent()
var awaiting_verification_dict = {}

func start(player_id):

	awaiting_verification_dict[player_id] = {"timestamp": OS.get_unix_time()}

	print("awaiting_verification_dict")
	print(awaiting_verification_dict)

	main_interface.request_token(player_id)


func create_player_container(player_id):
	var new_player_container = player_container_scene.instance()
	new_player_container.name = str(player_id)
	get_parent().add_child(new_player_container, true)
	var player_container = get_node("../" + str(player_id))
	fill_player_container(player_container)
	
	
	
func fill_player_container(player_container):
	player_container.player_stats =  ServerGameData.test_data


func verify(player_id, token):
	var token_verification = false
	while OS.get_unix_time() - int(token.right(64)) <= TOKEN_EXPIRATION_TIME:
		if main_interface.expected_tokens.has(token):
			token_verification = true
			print("Good TOKEN")
			create_player_container(player_id)
			awaiting_verification_dict.erase(player_id)
			main_interface.expected_tokens.erase(token)
			break
		else:
			print("Bad TOKEN")
			yield(get_tree().create_timer(2), "timeout")
	
	main_interface.return_token_verification_result(player_id, token_verification)
	
	if token_verification == false:
		awaiting_verification_dict.erase(player_id)
		main_interface.network.disconnect_peer(player_id)

func _on_VerificationExpiredTimer_timeout():
	var current_time = OS.get_unix_time()
	var start_time
	if awaiting_verification_dict == {}:
		pass
	else:
		for key in awaiting_verification_dict.keys():
			start_time = awaiting_verification_dict[key].timestamp
			if current_time - start_time >= TOKEN_EXPIRATION_TIME :
				awaiting_verification_dict.erase(key)
				var connected_peers = Array(get_tree().get_network_connected_peers())
				if connected_peers.has(key):
					main_interface.return_token_verification_result(key, false)
					main_interface.network.disconnect_peer(key)
	
	print("Awaiting Verification: ")
	print(awaiting_verification_dict)
	




