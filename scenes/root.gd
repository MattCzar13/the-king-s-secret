extends Node

## This is our root node, so this script is our "main".

## TODO: a lot of stuff

func _ready() -> void:
	Globals.example_signal.connect(print.bind("Example signal received!"))

func _physics_process(delta: float) -> void:
	pass
