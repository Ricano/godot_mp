extends Node


var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 32125
var max_players = 100

var certificate = load("res://certificate/x509_certificate.crt")
var key = load("res://certificate/x509_key.key")

func _ready():
	start_server()

func _process(_delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
 
func start_server():
	
	network.set_dtls_enabled(true)
	network.set_dtls_key(key)
	network.set_dtls_certificate(certificate)
	
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	log_time()
	print("GATEWAY SERVER started")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(player_id):
	log_time()
	print(str(player_id) + " connected to gateway")

	
func _on_peer_disconnected(player_id):
	log_time()
	print(str(player_id) + " dicconnected from gateway")


remote func login_request(username, password):
	log_time()
	print("Login_request received")
	print(username)
	print(password)
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.authenticate_player(username, password, player_id)

func return_login_request(response, player_id, token):
	rpc_id(player_id, "receive_login_response", response, token)
	network.disconnect_peer(player_id)

remote func new_account_request(username, password):
	var player_id=custom_multiplayer.get_rpc_sender_id()
	var valid = is_new_account_request_valid()
	if valid:
		Authenticate.create_account(username.to_lower(), password, player_id)
	else:
		return_create_account_request(valid, player_id, 1)
			
		
func return_create_account_request(result, player_id, message):
	rpc_id(player_id, "receive_create_new_account_response", result, message)
	# 1 = failed to create, 2 = existingt username, 3 = welcome
	network.disconnect_peer(player_id)

func is_new_account_request_valid():
	log_time()
	print("Performing server side validations")
	# new accountserver side verifications go here 
	return true
	
	
func log_time():
	var dt = OS.get_datetime()
	var ticks = str(OS. get_ticks_msec())
	print(ticks)
	print(dt['year'],"/",dt['month'],"/",dt['day']," ",dt['hour'],":",dt['minute'],":",dt['second'], ":", ticks.right(len(ticks)-3) )
	
	

