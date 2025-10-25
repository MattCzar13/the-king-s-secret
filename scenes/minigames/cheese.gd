extends Sprite2D

var dragging = false

func _input(event):
	if Input.is_action_just_pressed("Draw"):
		if get_rect().has_point(to_local(event.position)):
			dragging = true
	elif Input.is_action_just_released("Draw"):
		dragging = false

	if dragging:
		global_position = get_global_mouse_position()
