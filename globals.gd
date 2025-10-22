extends Node

# This is our global script. It is autoloaded, so you can reference it from
# any script you make by using "Globals." at the start. For example, to access
# a variable declared inside this script, do
## Globals.variable_name

# TODO: Spawning messengers from the starting castle
# TODO: Moving messengers along the path
# TODO: Give messengers an actual text message to deliver, check if it is "correct" when delivered
# TODO: Give towers encryption / decryption functionality to messengers that walk through them
# TODO: Minigames
# TODO: Include towers in path calculation
# TODO: Let the player place any kind of tower manually (through a menu, or hotkeys)
# TODO: Randomly spawn enemies at spawn points, with a limit on how many can exist at a time
# TODO: Pathfinding for enemies (navigation agent / region nodes + collision shapes)
# TODO: Enemy actions (sabotaging messages, attacking messengers, etc etc)


signal example_signal

signal update_path

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
