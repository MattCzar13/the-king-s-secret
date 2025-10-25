extends Control

## This debug panel allows you to manually fire any Global signal at runtime,
## so you can simulate key parts of the game happening to test connectivity

@export var list : Control
@export var panel : Control

# A list of Godot's default signals (we shouldn't be manually firing these)
var hide_list : Array[String] = [
	"ready",
	"renamed",
	"tree_entered",
	"tree_exiting",
	"tree_exited",
	"child_entered_tree",
	"child_exiting_tree",
	"child_order_changed",
	"replacing_by",
	"editor_description_changed",
	"editor_state_changed",
	"script_changed",
	"property_list_changed"
]

func _physics_process(delta: float) -> void:
	
	# Toggle panel visibility with specific key press
	if Input.is_action_just_pressed("debug_menu_signals"):
		panel.visible = !panel.visible

func _ready() -> void:
	# Unhide myself
	visible = true
	
	# Hide the panel by default
	panel.visible = false
	
	# Make a button for every Global signal
	for x : Dictionary in Globals.get_signal_list():
		# Skip non-user created signals, to make things clearer
		if hide_list.has(x["name"]):
			continue
		
		# Make the button, use the signal's name as its text, spawn it in the list
		var button : Button = Button.new()
		button.text = x["name"]
		button.pressed.connect(attempt_fire_signal.bind(x["name"]))
		list.add_child(button)

# Helper function to fire the signal and handle an error
func attempt_fire_signal(signal_name : String):
	if (signal_name == "minigame_caesar_decrypt"):
		#sets the secret key arg
		#var secret_key = 7
		var secret_key = randi_range(0, 25)
		var result : Error = Globals.emit_signal(signal_name, secret_key)
		if result:
			printerr("Either this signal isn't connected to anything, or it requires arguments (this menu doesn't support those)!")
	else:
		var result : Error = Globals.emit_signal(signal_name)
		if result:
			printerr("Either this signal isn't connected to anything, or it requires arguments (this menu doesn't support those)!")
