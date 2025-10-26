extends Node

## This is our root node, so this script is our "main".

## TODO: a lot of stuff

# We should have a reference to our level node, so we can easily
# pause and unpause the level during minigames (you can pause nodes directly)
@export var level : Node

func _ready() -> void:
	Globals.example_signal.connect(print.bind("Example signal received!"))
	
	Globals.minigame_caesar_decrypt.connect(_on_minigame_caesar_decrypt)
	Globals.minigame_vigenere_decrypt.connect(_on_minigame_vignere_decrypt)
	Globals.minigame_threads_of_fate.connect(_on_minigame_threads_of_fate)
	
	Globals.minigame_success.connect(_on_minigame_success)
	Globals.minigame_fail.connect(_on_minigame_fail)
	
	# when a message is delivered, check if the delivery amount has hit the goal
	Globals.message_delivered.connect(win_condition_message_check)
	
	Globals.level_completed.connect(print.bind("you win!"))

func _physics_process(delta: float) -> void:
	pass

func win_condition_message_check():
	# Checks if the amount of successful deliveries has hit the goal for the level
	# and if so, the level has been completed
	if Globals.level_information["messages_delivered"] >= Globals.level_information["message_delivery_goal"]:
		Globals.level_completed.emit()

func _on_minigame_caesar_decrypt(data):
	print("Received:", data)
	var minigame_parent = $Minigames
	if(minigame_parent.get_child_count() > 0):
		printerr("Minigame already running!")
	else:
		var caesar_decrypt_minigame = preload("res://scenes/minigames/caesar_decrypt.tscn").instantiate()
		caesar_decrypt_minigame.set_secret_key(data)
		minigame_parent.add_child(caesar_decrypt_minigame)
		
func _on_minigame_vignere_decrypt(data):
	print("Received:", data)
	var minigame_parent = $Minigames
	if(minigame_parent.get_child_count() > 0):
		printerr("Minigame already running!")
	else:
		var vigenere_decrypt_minigame = preload("res://scenes/minigames/vigenere.tscn").instantiate()
		vigenere_decrypt_minigame.set_secret_key(data)
		minigame_parent.add_child(vigenere_decrypt_minigame)
		
func _on_minigame_threads_of_fate():
	var minigame_parent = $Minigames
	if(minigame_parent.get_child_count() > 0):
		printerr("Minigame already running!")
	else:
		var tof_minigame = preload("res://scenes/minigames/entropy_gen.tscn").instantiate()
		minigame_parent.add_child(tof_minigame)

func _on_minigame_success():
	var minigame_parent = $Minigames
	for child in minigame_parent.get_children():
		child.queue_free()
	print("You succeeded the minigame!")

func _on_minigame_fail():
	var minigame_parent = $Minigames
	for child in minigame_parent.get_children():
		child.queue_free()
	print("You failed the minigame!")
