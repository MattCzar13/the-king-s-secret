extends Node2D

@onready var thread = $thread
@onready var draw_timer = $thread/polling
@onready var entropy_label = $EntropyLabel
@onready var mouse = $mouse
@onready var cheese = $cheese
@onready var potion = $Potion

var entropy_value = 0.0

func calculate_entropy():
	var total = 0.0
	for pos in thread.points:
		total += pos.x * 0.08 + pos.y * 0.08
		
	entropy_value = fmod(total, 1000)  # range 0–999
	entropy_label.text = "Entropy: " + str(round(entropy_value)) # visible for debugging

func _on_analysis_button_up() -> void:
	calculate_entropy()
	Globals.entropy = entropy_value
	Globals.private_colour = Color.from_hsv(fmod(entropy_value / 1000.0, 1.0), 0.8, 0.9)
	potion.modulate = Globals.private_colour
	potion.show()

func _on_timer_timeout() -> void:
	thread.add_point(mouse.position)
	draw_timer.start()

func _on_finish_pressed() -> void:
	if thread.points.size() < 50:
		print("Not enough entropy!")
	else:
		attempt_fire_signal("minigame_success")

# Helper function to fire the signal and handle an error
func attempt_fire_signal(signal_name : String):
	var result : Error = Globals.emit_signal(signal_name)
	if result:
		printerr("Either this signal isn't connected to anything, or it is missing arguments!")
