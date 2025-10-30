extends Control
class_name PopupNode

signal closed

@export var title : Label
@export var content : Label

func _ready():
	visible = false

func _on_okay_pressed() -> void:
	closed.emit()
