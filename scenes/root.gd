extends Node

## This is our root node, so this script is our "main".

## List of level scenes (should be in order)
@export var level_list : Array[PackedScene]

@export var gamecontainer : Node
@export var levelcontainer : Node
@export var minigamecontainer : Node

@export var popup : PopupNode

func _ready() -> void:
	Globals.example_signal.connect(print.bind("Example signal received!"))
	
	Globals.minigame_caesar_modify.connect(_on_minigame_caesar_modify)
	Globals.minigame_vigenere_modify.connect(_on_minigame_vigenere_modify)
	Globals.minigame_caesar_decrypt.connect(_on_minigame_caesar_decrypt)
	Globals.minigame_vigenere_decrypt.connect(_on_minigame_vignere_decrypt)
	Globals.minigame_threads_of_fate.connect(_on_minigame_threads_of_fate)
	
	Globals.minigame_success.connect(_on_minigame_success)
	Globals.minigame_fail.connect(_on_minigame_fail)
	
	# when a message is delivered, check if the delivery amount has hit the goal
	Globals.message_delivered.connect(win_condition_message_check)
	
	Globals.level_completed.connect(print.bind("you win!"))
	
	Globals.send_popup.connect(show_popup)
	
	popup.visible = false
	
	Globals.level_number = 1
	load_level()

func _physics_process(delta: float) -> void:
	pass

func load_level():
	# Loads a level depending on the Global level number
	# If it didn't change, this essentially restarts the level
	
	print("Loading level #" + str(Globals.level_number) + "...")
	
	var packedscene = level_list.get(Globals.level_number - 1)
	if !packedscene:
		printerr("Could not find level " + str(Globals.level_number) + " in level list (position " + str(Globals.level_number - 1) + ")!")
		printerr("Loading first level in array instead.")
		packedscene = level_list.front()
		Globals.level_number = 1
		if !packedscene:
			printerr("Okay there's just no levels in the level list >:(")
			return
	
	for x in levelcontainer.get_children():
		x.queue_free()
	
	levelcontainer.add_child(packedscene.instantiate())
	
	print("Level #" + str(Globals.level_number) + " loaded successfully!")

func show_popup(title : String, content : String):
	# Unhide the popup node, pause the game, await popup being closed, then unpause
	# This could be used for many cases (pause screen, info dump, etc)
	
	popup.title.text = title
	popup.content.text = content
	popup.visible = true
	gamecontainer.process_mode = Node.PROCESS_MODE_DISABLED
	
	await popup.closed
	
	match title:
		"Level complete!":
			Globals.level_number += 1
			load_level()
		"Level failed!":
			load_level()
	
	popup.visible = false
	gamecontainer.process_mode = Node.PROCESS_MODE_INHERIT

func win_condition_message_check():
	# Checks if the amount of successful deliveries has hit the goal for the level
	# and if so, the level has been completed
	if Globals.level_information["messages_delivered"] >= Globals.level_information["message_delivery_goal"]:
		Globals.level_completed.emit()

func _on_minigame_caesar_decrypt(data):
	print("Received:", data)
	var minigame_parent = minigamecontainer
	if(minigame_parent.get_child_count() > 0):
		printerr("Minigame already running!")
	else:
		var caesar_decrypt_minigame = preload("res://scenes/minigames/caesar_decrypt.tscn").instantiate()
		caesar_decrypt_minigame.set_secret_key(data)
		minigame_parent.add_child(caesar_decrypt_minigame)
		
func _on_minigame_vignere_decrypt(data):
	print("Received:", data)
	var minigame_parent = minigamecontainer
	if(minigame_parent.get_child_count() > 0):
		printerr("Minigame already running!")
	else:
		var vigenere_decrypt_minigame = preload("res://scenes/minigames/vigenere.tscn").instantiate()
		vigenere_decrypt_minigame.set_secret_key(data)
		minigame_parent.add_child(vigenere_decrypt_minigame)
		
func _on_minigame_threads_of_fate():
	var minigame_parent = minigamecontainer
	if(minigame_parent.get_child_count() > 0):
		printerr("Minigame already running!")
	else:
		var tof_minigame = preload("res://scenes/minigames/entropy_gen.tscn").instantiate()
		minigame_parent.add_child(tof_minigame)

func _on_minigame_caesar_modify(input : String, key: int, encrypt : bool):
	print("minigame started with input ", input, ", key ", key, " and encrypt ", encrypt)
	var minigame_parent = minigamecontainer
	if(minigame_parent.get_child_count() > 0):
		printerr("Minigame already running!")
	else:
		var caesar_modify_minigame = preload("res://scenes/minigames/caesar_encrypt.tscn").instantiate()
		caesar_modify_minigame.plaintext = input
		caesar_modify_minigame.secret_key = key
		caesar_modify_minigame.encrypt = encrypt
		minigame_parent.add_child(caesar_modify_minigame)
		
func _on_minigame_vigenere_modify(input : String, key: String, encrypt : bool):
	print("minigame started with input ", input, ", key ", key, " and encrypt ", encrypt)
	var minigame_parent = minigamecontainer
	if(minigame_parent.get_child_count() > 0):
		printerr("Minigame already running!")
	else:
		var vigenere_modify_minigame = preload("res://scenes/minigames/vigenere_modify.tscn").instantiate()
		vigenere_modify_minigame.plaintext = input
		vigenere_modify_minigame.ciphertext = Globals.vigenere(input, key, encrypt)
		vigenere_modify_minigame.secret_key = key
		vigenere_modify_minigame.encrypt = encrypt
		minigame_parent.add_child(vigenere_modify_minigame)

func _on_minigame_success():
	var minigame_parent = minigamecontainer
	for child in minigame_parent.get_children():
		child.queue_free()
	print("You succeeded the minigame!")

func _on_minigame_fail():
	var minigame_parent = minigamecontainer
	for child in minigame_parent.get_children():
		child.queue_free()
	print("You failed the minigame!")
