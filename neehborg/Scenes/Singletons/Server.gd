extends Node


var network = NetworkedMultiplayerENet.new()

var ip =  "127.0.0.1"

var port = 32123

var token

func connect_to_server():
	
	
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "on_connection_failed")
	network.connect("connection_succeeded", self, "on_connection_succeeded")

func on_connection_failed():
	Gateway.log_time()
	print("Failed to connect")
	
func on_connection_succeeded():
	Gateway.log_time()
	print("Successfully connected to Game Server")
	


func request_skill_damage_from_server(skill_name, requester_id):
	rpc_id(NetworkedMultiplayerPeer.TARGET_PEER_SERVER, "provide_skill_damage", skill_name, requester_id)
	
	
remote func receive_skill_damage_from_server(server_damage, requester_id):
	instance_from_id(requester_id).set_damage(server_damage)


func request_player_stats_from_server():
	rpc_id(1, "provide_player_stats")
	
	
remote func receive_player_stats_from_server(stats):
	get_node("/root/SceneHandler/PlayerStats").load_player_stats(stats)

remote func request_token():
	var sender = get_tree().get_rpc_sender_id()
	Gateway.log_time()
	print("received token request from game server")
	print("sending token: ", token)
	rpc_id(sender, "response_token", token)
	
remote func return_token_verification_result(result):
	Gateway.log_time()
	print("Received token verification result from game_server")
	if result == true:
		get_node("../SceneHandler/LoginScreen").queue_free()
		get_node("../SceneHandler").switch_to("stats")
		
		print("Token verification success \\0/")
	else:
		print("Login failed, BAD Token verification")
		get_node("../SceneHandler/LoginScreen").login_button.disabled = false
	
