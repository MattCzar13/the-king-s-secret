extends CharacterBody2D

const SPEED = 420.0
signal mouse_moving
signal mouse_stopped

func _physics_process(delta: float) -> void:
	var target = get_parent().get_child(0).position
	
	if (position.distance_to(target) > 100):
		var direction = global_position.direction_to(target)
		look_at(target)
		velocity = direction * SPEED
		mouse_moving.emit()
	else:
		velocity = Vector2(0, 0)
		mouse_stopped.emit()

	move_and_slide()
