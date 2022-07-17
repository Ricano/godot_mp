extends Node

onready var username_input = "Test"
onready var password_input = "Test123"
onready var login_button = $LoginButton


func _on_LoginButton_pressed():
	if username_input == "" or password_input == "":
		print("POP UP: Provide valid login credentials.")
	else:
		login_button.disabled = true
		var username = username_input
		var password = password_input
		print("Trying to login ...")
		Gateway.connect_to_server(username, password)
		
