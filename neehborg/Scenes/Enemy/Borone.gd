extends KinematicBody2D


const speed = 250


var destination : Vector2
var velocity : Vector2
var is_moving := true
var global_movement : Vector2

var is_firing := false

var shot = preload("res://Scenes/Shot.tscn")

const MARGIN = 128

var left
var right

var up
var down

signal was_hitted(damage)

var health = 10

func _ready():
	left = MARGIN
	right = get_viewport_rect().size.x - MARGIN
	up = get_viewport_rect().size.y - MARGIN * 2
	down = get_viewport_rect().size.y - MARGIN
	
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var random_0_or_1 = random.randi()%2
	var destination_x = [left, right][random_0_or_1]
	var destination_y = 200
	
	destination.x = destination_x
	destination.y = destination_y


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move()



func move():
	velocity = position.direction_to(destination) * speed
	
	if position.distance_to(destination) > 50:
		global_movement = move_and_slide(velocity)
	else:
		destination.x = left if destination.x > get_viewport().size.x/2 else right

func hitted(body):
	health -=body.damage
	emit_signal("was_hitted", body.damage)
	
		
func shoot():
	var new_shot = shot.instance()
	new_shot.global_position = global_position
	new_shot.velocity = global_position.direction_to(get_parent().get_node("Player").global_position)
	new_shot.set_collision_mask_bit(4, true)
	get_parent().add_child(new_shot)
	
	
func _on_ShotTimer_timeout():
	shoot()
	
