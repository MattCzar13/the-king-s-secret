extends Node

## This is our root node, so this script is our "main".

## TODO: a lot of stuff

# We should have a reference to our level node, so we can easily
# pause and unpause the level during minigames (you can pause nodes directly)
@export var level : Node

func _ready() -> void:
	Globals.example_signal.connect(print.bind("Example signal received!"))
	
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
