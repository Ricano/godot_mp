extends Node


var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 32125


var username
var password

func _ready():
	pass

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
 
func connect_to_server(_username, _password):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	
	username = _username
	password = _password
	
	network.create_client(ip, port)
	
	set_custom_multiplayer(gateway_api)
	
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded():
	print("Connected to Login Server")
	request_login(username, password)

	
func _on_connection_failed():
	print("Failed to connect to Login Server")
	print("Pop-up SERVER DOWN")
	get_node("../SceneHandler/LoginScreen/LoginButton").disabled = false


func request_login(username, password):
	print("Connecting to gateway to request login")
	print(username)
	print(password)
	rpc_id(1, "login_request", username, password)
	username = ""
	password = ""

remote func receive_login_response(response, token):
	print("Login response received")
	if response==true:
		print("Login response: OK")
		print("Connecting to Game Server")
		Server.token = token
		Server.connect_to_server()
	else:
		print("POP UP - Please provide correct username and password")
		get_node("../SceneHandler/LoginScreen/LoginButton").disabled = false
	network.disconnect("connection_failed", self, "_on_connection_failed")	
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")	
