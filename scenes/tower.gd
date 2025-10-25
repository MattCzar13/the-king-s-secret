extends Node2D
class_name Tower

# Tower object
# Serves as intermediate points for messages to pass through
# Detects colliding messengers, reads their message, and changes it accordingly
# The tower needs to be prepared through a minigame

# Assign this tower a "type", which decides what code it runs when a message runs through it
@export_enum("None", "Caesar Encrypt", "Caesar Decrypt") var type : String:
	set(value):
		type = value
		typelabel.text = type

@export var typelabel : Label

@export var caesar_key : int = 0

# The last message that ran through this tower, updated with each passing message
var input_message : String = ""

# Change messengers's message (if the tower has been setup correctly)
func _on_area_2d_area_entered(area: Area2D) -> void:
	if !area.get_parent():
		return
	var messenger = area.get_parent()
	
	if messenger is Messenger:
		read_and_write(messenger)

func read_and_write(m : Messenger):
	# This is where the tower reads the message and changes it,
	# according to what type of tower this is.
	
	input_message = m.message
	
	match type:
		"Caesar Encrypt":
			# Encrypt the passing message
			m.message = Globals.shift_message(input_message, caesar_key, true)
		"Caesar Decrypt":
			# Decrypt the passing message
			m.message = Globals.shift_message(input_message, caesar_key, false)
		_:
			# Do nothing to the message
			pass

func modify():
	# This is where the tower opens a minigame depending on what type it is
	# The result of the minigame is saved inside this tower (caesar key, etc)
	
	match type:
		"Caesar Encrypt":
			Globals.minigame_caesar_modify.emit(input_message, true)
		"Caesar Decrypt":
			Globals.minigame_caesar_modify.emit(input_message, false)
		_:
			pass
	
	# Wait for the minigame to finish, and read the results
	
	var data : Dictionary = await Globals.minigame_end_data
	
	if data.has("caesar_key"):
		caesar_key = data["caesar_key"]


func _on_modify_button_pressed() -> void:
	modify()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 2:
			queue_free()
			Globals.update_path.emit()
