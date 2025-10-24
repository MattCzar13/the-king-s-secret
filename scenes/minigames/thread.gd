extends Line2D

@onready var draw_timer = $polling

func _on_mouse_mouse_moving() -> void:
	if draw_timer.is_stopped():
		draw_timer.start()

func _on_mouse_mouse_stopped() -> void:
	draw_timer.stop()
