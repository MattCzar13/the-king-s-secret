extends Control

@onready var key_label = $VBoxContainer/CaesarCipher/SecretKey
@onready var plaintext_label = $"VBoxContainer/CaesarCipher/plaintext"
@onready var ciphertext_label = $"VBoxContainer/CaesarCipher/ciphertext"

var plaintext = Globals.message
var encrypt : bool = true

func _ready() -> void:
	plaintext_label.text = plaintext
	ciphertext_label.text = plaintext
	key_label.text = "KEY: %s (%d)" % [Globals.alpha[0], 0]

func _on_key_slider_value_changed(key: float) -> void:
	key_label.text = "KEY: %s (shifting plaintext by %d)" % [Globals.alpha[key], key]
	ciphertext_label.text = Globals.shift_message(plaintext, key, encrypt)
	

func _on_submit_button_pressed() -> void:
	# Close the minigame
	Globals.minigame_fail.emit()
	
	# Share the data from this minigame
	var data : Dictionary
	data["caesar_key"] = int($"VBoxContainer/CaesarCipher/KeySlider".value)
	Globals.minigame_end_data.emit(data)
