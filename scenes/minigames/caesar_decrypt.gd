extends Control

@onready var key_label = $"VBoxContainer/CaesarCipher/SecretKey"
@onready var plaintext_label = $"VBoxContainer/CaesarCipher/plaintext"
@onready var ciphertext_label = $"VBoxContainer/CaesarCipher/ciphertext"

var secret_key: int
var ciphertext: String = Globals.shift_message(Globals.message, secret_key, true)

func _ready() -> void:
	ciphertext_label.text = ciphertext
	plaintext_label.text = ciphertext
	key_label.text = "KEY: %s (%d)" % [Globals.alpha[0], 0]

# TODO visualization for shifting letters

func _on_key_slider_value_changed(key: float) -> void:
	key_label.text = "KEY: %s (shifting plaintext_label by %d)" % [Globals.alpha[key], key]
	plaintext_label.text = Globals.shift_message(ciphertext, key, false)

func _on_submit_button_pressed() -> void:
	if(secret_key == int($"VBoxContainer/CaesarCipher/KeySlider".value)):
		attempt_fire_signal("minigame_success")
	else:
		attempt_fire_signal("minigame_fail")

func set_secret_key(key: int):
	#sets the seccret key and updates the cypher text
	secret_key = key
	ciphertext = Globals.shift_message(Globals.message, secret_key, true)
	
# Helper function to fire the signal and handle an error
func attempt_fire_signal(signal_name : String):
	var result : Error = Globals.emit_signal(signal_name)
	if result:
		printerr("Either this signal isn't connected to anything, or it is missing arguments!")
