extends Node



signal swiped(direction)
signal swipe_canceled(position)
signal just_touched(position)

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3


const MINIMUM_SWIPE_DISTANCE := 20

onready var timer = $Timer

var swipe_start_position: Vector2 

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		start_detection(event.position)
	elif not timer.is_stopped():
		end_detection(event.position)

func start_detection(position):
	swipe_start_position = position
	timer.start()


func end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_position)
	if abs(direction.x)+abs(direction.y) < MINIMUM_SWIPE_DISTANCE:
		emit_signal("just_touched", swipe_start_position)
	else:
		emit_signal("swiped", direction.normalized())

func _on_Timer_timeout():
	emit_signal("swipe_canceled", swipe_start_position)
