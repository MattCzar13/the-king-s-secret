extends Control
class_name Menus

@export var build_options : Array[Button]

signal message_toggle(toggled_on : bool)

@export var player_progress_bar : ProgressBar
@export var enemy_progress_bar : ProgressBar

func _ready():
	Globals.building_action_done.connect(disable_build_options.bind(false))

func _on_caesar_e_pressed() -> void:
	Globals.building_action_ready.emit("Caesar Encrypt")
	disable_build_options(true)

func _on_caesar_d_pressed() -> void:
	Globals.building_action_ready.emit("Caesar Decrypt")
	disable_build_options(true)

func _on_vigenere_e_pressed() -> void:
	Globals.building_action_ready.emit("Vigenere Encrypt")
	disable_build_options(true)

func _on_vigenere_d_pressed() -> void:
	Globals.building_action_ready.emit("Vigenere Decrypt")
	disable_build_options(true)

func disable_build_options(disabled : bool):
	for x in build_options:
		x.disabled = disabled

func _on_check_button_toggled(toggled_on: bool) -> void:
	message_toggle.emit(toggled_on)
