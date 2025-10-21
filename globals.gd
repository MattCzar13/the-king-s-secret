extends Node

# This is our global script. It is autoloaded, so you can reference it from
# any script you make by using "Globals." at the start. For example, to access
# a variable declared inside this script, do
## Globals.variable_name

signal example_signal

signal message_delivered

signal minigame_start_type_a
signal minigame_start_type_b
signal minigame_start_type_c
signal minigame_success
signal minigame_fail

signal level_completed
signal level_failed
signal level_load(number : int)

var level_information : Dictionary = {
	"messages_delivered" : 0,
	"message_delivery_goal" : 4
}
