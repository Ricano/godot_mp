extends Node

var network = NetworkedMultiplayerENet.new()
var port = 32126
var gateway_api = MultiplayerAPI.new()

var max_players = 100


var game_servers_dict = {}

# Called when the node enters the scene tree for the first time.
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
	
	print("GameServerHub started")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(game_server_id):
	print("Game Server" + str(game_server_id) + " CONNECTED")
	
	game_servers_dict["GameServer1"] = game_server_id
	print(game_servers_dict)
	
func _on_peer_disconnected(game_server_id):
	print("Game Server" + str(game_server_id) + " DISCONNECTED")
	

func distribute_login_token(token, game_server):
	print("game_servers_dict")
	print(game_servers_dict)
	var game_server_peer_id = game_servers_dict[game_server]
	rpc_id(game_server_peer_id, "receive_login_token", token)
