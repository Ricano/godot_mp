extends Node




var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 32126

onready var game_server = get_node("/root/Server")

func _ready():
	connect_to_server()


func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
 
func connect_to_server():
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded():
	print("Connected to Game Server HUB")

	
func _on_connection_failed(gateway_id):
	print("FAILED to connect to Game Server HUB")


remote func receive_login_token(token):
	print("Receiving login token")
	game_server.expected_tokens.append(token)
