extends Node2D
class_name Enemy

# Enemy object
# Wanders inside the area it's placed in
# When it detects a messenger, it steals their message

var target_position : Vector2
var home : Vector2

@export var timer : Timer
@export var cooldown_timer : Timer

var on_cooldown : bool = false

signal make_decision(me : Enemy)
signal message_stolen

func _ready():
	target_position = global_position
	home = global_position

func _physics_process(delta: float) -> void:
	if position.distance_to(target_position) >= 1.0:
		position = position.move_toward(target_position, 10.0)

func _on_timer_timeout() -> void:
	if on_cooldown:
		return
	
	timer.wait_time = randf_range(1.0, 2.0)
	make_decision.emit(self)

func start_cooldown():
	cooldown_timer.start()
	on_cooldown = true
	target_position = home

func _on_cooldown_timeout() -> void:
	on_cooldown = false
	cooldown_timer.stop()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !area.get_parent() or on_cooldown:
		return
	var messenger = area.get_parent()
	
	if messenger is Messenger:
		if messenger.message == Globals.message:
			message_stolen.emit()
		start_cooldown()
