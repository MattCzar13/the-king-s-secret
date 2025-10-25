extends Control
class_name Menus

@export var build_options : Array[Button]

func _ready():
	Globals.building_action_done.connect(disable_build_options.bind(false))

func _on_caesar_e_pressed() -> void:
	Globals.building_action_ready.emit("Caesar Encrypt")
	disable_build_options(true)

func _on_caesar_d_pressed() -> void:
	Globals.building_action_ready.emit("Caesar Decrypt")
	disable_build_options(true)

func disable_build_options(disabled : bool):
	for x in build_options:
		x.disabled = disabled
