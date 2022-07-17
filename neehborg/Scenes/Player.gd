extends KinematicBody2D

signal was_hitted(damage)

var speed := 0.0
const MAX_SPEED = 500

var acceleration := 1500.0

var destination : Vector2
var velocity : Vector2
var is_moving := false
var global_movement : Vector2

var health = 10

var is_firing := false

var shot = preload("res://Scenes/Shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if name == "Player":
		move(delta)
	




func move(delta):
	if not is_moving:
		speed = 0
	else:
		speed +=  acceleration * delta
		
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		velocity = position.direction_to(destination) * speed
		
		if position.distance_to(destination) > 10:
		
			global_movement = move_and_slide(velocity)
		else:
			is_moving = false


func _on_SwipeDetector_swiped(direction):
	var new_shot = shot.instance()
	new_shot.global_position = global_position
	new_shot.velocity += direction
	new_shot.set_collision_mask_bit(5, true)
	get_parent().add_child(new_shot)


func _on_SwipeDetector_swipe_canceled(position):
	print("SWIPE CANCELED - make noise")


func _on_SwipeDetector_just_touched(position):
	is_moving=true
	destination = position
	
func hitted(body):
	health -=body.damage
	emit_signal("was_hitted", body.damage)
	
	
