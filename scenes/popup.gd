extends Control
class_name PopupNode

signal closed

@export var title : Label
@export var content : Label

func _ready():
	visible = false
	
	var styleBox = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", Color(0, 0, 0))
	add_theme_stylebox_override("panel", styleBox)

func _on_okay_pressed() -> void:
	closed.emit()
