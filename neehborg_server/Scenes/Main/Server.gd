extends Node


var network = NetworkedMultiplayerENet.new()
var port = 32123
var max_players = 100


const TOKEN_EXPIRATION_TIME = 30

var expected_tokens = []


onready var attack_actions = $Attack
onready var player_verification_process = $PlayerVerification


# Called when the node enters the scene tree for the first time.
func _ready():
	start_server()
 
func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(player_id):
	print(player_id, " CONNECTED")
	player_verification_process.start(player_id)

func _on_peer_disconnected(player_id):
	print(player_id, " DISCONNECTED")
	get_node(str(player_id)).queue_free()



remote func provide_skill_damage(skill_name, requester_id):
	var player_id = get_tree().get_rpc_sender_id()
	var damage = attack_actions.provide_skill_damage(skill_name, player_id)
	rpc_id(player_id, "receive_skill_damage_from_server", damage, requester_id)
	
remote func provide_player_stats():
	var player_id = get_tree().get_rpc_sender_id()
	
	var player_stats = get_node(str(player_id)).player_stats
	rpc_id(player_id, "receive_player_stats_from_server", player_stats)
	


func _on_TokenExpirationTimer_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	
	if expected_tokens == []:
		pass
	else:
		for i in range(expected_tokens.size()-1, -1, -1): #counting backwards to prevent array element jumps on deletion
			token_time = int(expected_tokens[i].right(64))
			# what is right of the 64th element ( unix time part)
			if current_time - token_time >= TOKEN_EXPIRATION_TIME:
				expected_tokens.remove(i)
	print("Expected Tokens")
	print(expected_tokens)
				
	

func request_token(player_id):
	player_id = get_tree().get_rpc_sender_id()	
	print("requesting token from player")
	rpc_id(player_id, "request_token")
	
	
remote func response_token(token):
	print("received player token: ", token)

	var player_id = get_tree().get_rpc_sender_id()
	print("#################")
	print("starting verification process")
	print("player_id")
	print(player_id)
	print("token")
	print(token)
	print("#################")
	player_verification_process.verify(player_id, token)	


func return_token_verification_result(player_id, result):
	print("Returning token verification result")
	rpc_id(player_id, "return_token_verification_result", result)
