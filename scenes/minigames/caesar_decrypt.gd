extends Control

@onready var key_label = $VBoxContainer/CaesarCipher/SecretKey
@onready var plaintext_label = $"VBoxContainer/CaesarCipher/plaintext"
@onready var ciphertext_label = $"VBoxContainer/CaesarCipher/ciphertext"

var secret_key = randi_range(0, 25)
var ciphertext: String = Globals.shift_plaintext_label(Globals.message, secret_key, true)

func _ready() -> void:
	ciphertext_label.text = ciphertext
	plaintext_label.text = ciphertext
	key_label.text = "KEY: %s (%d)" % [Globals.alpha[0], 0]

# TODO visualization for shifting letters

func _on_key_slider_value_changed(key: float) -> void:
	key_label.text = "KEY: %s (shifting plaintext_label by %d)" % [Globals.alpha[key], key]
	plaintext_label.text = Globals.shift_plaintext_label(ciphertext, key, false)
