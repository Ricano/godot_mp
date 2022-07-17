extends Node


var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 32125
var max_players = 100

func _ready():
	start_server()

func _process(_delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
 
func start_server():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	print("GATEWAY SERVER started")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(player_id):
	print(str(player_id) + " connected to gateway")

	
func _on_peer_disconnected(player_id):
	print(str(player_id) + " dicconnected from gateway")


remote func login_request(username, password):
	print("Login_request received")
	print(username)
	print(password)
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.authenticate_player(username, password, player_id)

func return_login_request(response, player_id, token):
	rpc_id(player_id, "receive_login_response", response, token)
	network.disconnect_peer(player_id)

