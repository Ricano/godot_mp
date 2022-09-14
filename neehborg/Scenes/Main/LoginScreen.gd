extends Node

onready var username_input = "test1"
onready var password_input = "Test123"
onready var login_button = $LoginButton



onready var create_username_input = "Test1"
onready var create_password_input = "Test123"
onready var repeat_password_input = "Test123"
onready var create_account_button = $NewAccountButton


func _on_LoginButton_pressed():
	if username_input == "" or password_input == "":
		Gateway.log_time()
		
		print("POP UP: Provide valid login credentials.")
	else:
		login_button.disabled = true
		var username = username_input
		var password = password_input
		Gateway.log_time()
		print("Trying to login ...")
		Gateway.connect_to_server(username, password, false)
		


func _on_NewAccountButton_pressed():
	
	if is_valid_new_account():
		create_account_button.disabled = true
		var username = create_username_input
		var password = create_password_input
		Gateway.connect_to_server(username, password, true)

func is_valid_new_account():
	# new account verify steps go here 
	
	return true
