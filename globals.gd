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

signal send_popup(title : String, content : String)

signal example_signal

signal update_path

signal message_delivered

signal minigame_caesar_modify(input : String, encrypt : bool)
signal minigame_caesar_decrypt(key)
signal minigame_vigenere_decrypt(key)
signal minigame_threads_of_fate
signal minigame_success
signal minigame_fail
signal minigame_end_data(data : Dictionary)

signal building_action_ready(type : String)
signal building_action_done

signal level_completed
signal level_failed
signal level_load(number : int)

var level_information : Dictionary = {
	"messages_delivered" : 0,
	"message_delivery_goal" : 4
}

var alpha: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
							"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var message: String = "ALL HAIL THE KING"

var entropy: int = 0
var private_colour: Color

func shift_message(text: String, key: int, encrypt: bool) -> String:
	var shifted = ""

	for i in text.length():
		if text[i] == " ":  # ignore spaces
			shifted += " "
			continue

		if encrypt:
			shifted += alpha[(text.unicode_at(i) - 65 + key) % 26]
		else:
			shifted += alpha[(text.unicode_at(i) - 65 - key) % 26]

	return shifted

func vigenere(text: String, key: String, encrypt: bool) -> String:
	#ignote non-alphabet chars
	var filtered_key := ""
	for i in range(key.length()):
		var code := key.unicode_at(i)
		if (code >= 65 and code <= 90) or (code >= 97 and code <= 122):
			filtered_key += key[i]
	
	key = filtered_key
	
	if(key.length() < 1):
		printerr("Vigenere key has invalid length")
		return ""
	var plaintext = ""
	var key_index = 0

	for index in text.length():
		if text[index] == " ":
			plaintext += " "
		else:
			plaintext += Globals.shift_message(text[index], key.unicode_at(key_index % key.length()) - 65, encrypt)
			key_index += 1;
	
	return plaintext
