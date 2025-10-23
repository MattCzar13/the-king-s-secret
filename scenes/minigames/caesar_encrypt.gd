extends Control

@onready var key_label = $VBoxContainer/CaesarCipher/SecretKey
@onready var plaintext_label = $"VBoxContainer/CaesarCipher/plaintext"
@onready var ciphertext_label = $"VBoxContainer/CaesarCipher/ciphertext"

var plaintext = Globals.message

func _ready() -> void:
	plaintext_label.text = plaintext
	ciphertext_label.text = plaintext
	key_label.text = "KEY: %s (%d)" % [Globals.alpha[0], 0]

func _on_key_slider_value_changed(key: float) -> void:
	key_label.text = "KEY: %s (shifting plaintext by %d)" % [Globals.alpha[key], key]
	ciphertext_label.text = Globals.shift_plaintext(plaintext, key, true)
	
