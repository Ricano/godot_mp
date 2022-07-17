extends Node


var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 32124


func _ready():
	start_server()

 
func start_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("peer_disconnected", self, "_on_connection_failed")


func _on_connection_succeeded():
	print("Connected to AUTHENTICATION SERVER")

	
func _on_connection_failed(_gateway_id):
	print("FAILED to connect to AUTHENTICATION SERVER")


func authenticate_player(username, password, player_id):
	print("Sending login request to Authentication Server")
	rpc_id(1, "authenticate_player", username, password, player_id)


remote func authentication_response(response, player_id, token):
	print("Received authentication response from Authentication Server")
	print("Replying to the player's login request")
	Gateway.return_login_request(response, player_id, token)
