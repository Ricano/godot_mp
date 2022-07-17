extends Node


var network = NetworkedMultiplayerENet.new()
var port = 32124
var max_servers = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	start_server()
 
func start_server():
	network.create_server(port, max_servers)
	get_tree().set_network_peer(network)
	print("Authentication Server started")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(gateway_id):
	print(gateway_id, " CONNECTED")
	
func _on_peer_disconnected(gateway_id):
	print(gateway_id, " DISCONNECTED")



remote func authenticate_player(username, password, player_id):
	
	print("################################")
	print("Authentication request received")
	print(username)
	print(password)
	print("################################")
	
	var response
	var token
	var gateway_id = get_tree().get_rpc_sender_id()

	print("Starting Authentication")

	if not PlayerData.data.has(username):
		print("User not found")
		response = false
	elif not PlayerData.data[username].password == password:
		print("Incorrect password")
		response = false
	else:
		print("Authentication succesfull")
		response = true
		
		token = generate_token()
		
		var gameserver = "GameServer1" # will be replaced with laod balance function
		
		GameServers.distribute_login_token(token, gameserver)

	print("Sending authentication response to gateway server")
	rpc_id(gateway_id, "authentication_response", response, player_id, token)
	
func generate_token():
	randomize()
	
	print("Generating token")
	var new_token
	var random_number = randi()
	var hashed = str(random_number).sha256_text()
	var timestamp = str(OS.get_unix_time())
	new_token = hashed + timestamp
	print("created token")
	print(new_token)
	
	return new_token
	# return str(randi()).sha256_text() + str(OS.get_unix_time())
