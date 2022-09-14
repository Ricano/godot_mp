extends Node


var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 32125

var certificate = load("res://resources/certificate/x509_certificate.crt")



var username
var password
var is_new_account

func _ready():
	log_time()
	print("Client started")	

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
 
func connect_to_server(_username, _password, _is_new_account):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	
	network.set_dtls_enabled(true)
	network.set_dtls_verify_enabled(false) #false for accept self-signed certificates
	network.set_dtls_certificate(certificate)
	
	username = _username
	password = _password
	is_new_account = _is_new_account
	
	network.create_client(ip, port)
	
	set_custom_multiplayer(gateway_api)
	
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded():
	log_time()
	print("Connected to Login Server")
	if is_new_account == true:
		request_create_account()
	else:	
		request_login()

	
func _on_connection_failed():
	log_time()
	
	print("Failed to connect to Login Server")
	print("Pop-up SERVER DOWN")
	get_node("../SceneHandler/LoginScreen/LoginButton").disabled = false


func request_login():
	log_time()
	print("Connecting to gateway to request login")
	print(username)
	print(password)
	rpc_id(1, "login_request", username, password.sha256_text())
	username = ""
	password = ""

func request_create_account():
	log_time()
	print("Connecting to gateway to request new account creation")
	print(username)
	print(password)
	rpc_id(1, "new_account_request", username, password.sha256_text())
	username = ""
	password = ""

remote func receive_login_response(response, token):
	log_time()
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

remote func receive_create_new_account_response(result, message):
	Gateway.log_time()
	print("results received")	
	if result == true:
		print("New account successfully created")
		print("You can now log in")
	else:
		if message == 1:
			print("Unable to create account. Try again")
		elif message== 2:
			print("Already existing username., Try a different one")
		get_node("../SceneHandler/LoginScreen/NewAccountButton").disabled=false
	network.disconnect("connection_failed", self, "_on_connection_failed")
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")
	
func log_time():
	
	
	var dt = OS.get_datetime()
	var ticks = str(OS. get_ticks_msec())
	
	print(dt['year'],"/",dt['month'],"/",dt['day']," ",dt['hour'],":",dt['minute'],":",dt['second'], ":", ticks.right(len(ticks)-3) )
#
#	var a = str(dt['year'])+"/"
#	var b = str(dt['month']) + "/"
#	var c = str(dt['day']) + " "
#	var d = str(dt['hour'])  + ":"
#	var e = str(dt['minute']) + ":"
#	var f = str(dt['second']) + ":"
#	var g = str(ticks.right(len(ticks)-3))
#
#
#	push_warning(a+b+c+d+e+f+g)
	
	
