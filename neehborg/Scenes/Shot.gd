extends KinematicBody2D



var velocity = Vector2()
var speed = 150000

var damage
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	Server.request_skill_damage_from_server("Shot", get_instance_id())
	



func _process(delta):
	move(delta)
	check_bonds()



func set_damage(server_damage):
	damage = server_damage

func move(delta):
	rotation = velocity.angle()+PI/2
	move_and_slide(velocity * speed * delta)

func check_bonds():
	if is_out_of_screen():
		queue_free()

func is_out_of_screen():
	var x = global_position.x
	var y = global_position.y
	var margin = 10
	
	var left = -margin
	var right = get_viewport_rect().size.x + margin
	var down = get_viewport_rect().size.y  + margin
	var up = -margin
	
	return  y > down or x < left or x > right or y < up


func make_damage():
	pass
	
