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
	GameServers.log_time()
	print("################################")
	print("Authentication request received")
	print(username)
	print(password)
	print("################################")
	
	var hashed_password
	var response
	var token
	var gateway_id = get_tree().get_rpc_sender_id()

	print("Starting Authentication")
	GameServers.log_time()
	
	if not PlayerData.data.has(username):
		print("User not found")
		response = false
	else:
		var player_salt = PlayerData.data[username].salt
		hashed_password = GenerateHashedPassword(password, player_salt)
	
		if not PlayerData.data[username].password == hashed_password:
			print("Incorrect password")
			response = false
		else:
			print("Authentication succesfull")
			response = true

			token = generate_token()
			var gameserver = "GameServer1" # will be replaced with load balance fu nction
			GameServers.distribute_login_token(token, gameserver)

	GameServers.log_time()
	print("Sending authentication response to gateway server")
	rpc_id(gateway_id, "authentication_response", response, player_id, token)
	
func generate_token():
	randomize()
	GameServers.log_time()
	print("Generating token")
	var new_token
	var random_number = randi()
	var hashed = str(random_number).sha256_text()
	var timestamp = str(OS.get_unix_time())
	new_token = hashed + timestamp
	GameServers.log_time()
	print("created token")
	print(new_token)
	
	return new_token
	# return str(randi()).sha256_text() + str(OS.get_unix_time())


remote func create_new_account(username, password, player_id):
	var gateway_id = get_tree().get_rpc_sender_id()
	var result
	var message
	if PlayerData.data.has(username):
		result = false
		message = 2
	else:
		result = true
		message = 3
		
		var salt = GenerateSalt()
		var hashed_password = GenerateHashedPassword(password, salt)
		PlayerData.data[username] = {"password": hashed_password, "salt": salt}
		PlayerData.save_player_data()
		
	rpc_id(gateway_id, "create_new_account_result", result, player_id, message)


func GenerateSalt():
	randomize()
	var salt = str(randi()).sha256_text()
	print("SALT: " + salt)
	return salt

func GenerateHashedPassword(password, salt):
	print(str(OS.get_system_time_msecs()))
	var hashed_password = password
	var rounds = pow(2, 18)
	print("Password: " + hashed_password)
	while rounds > 0:
		hashed_password = (hashed_password + salt).sha256_text()
		rounds -= 1
	print("Hashed Password: " + hashed_password)
	print(str(OS.get_system_time_msecs()))
	return hashed_password	
