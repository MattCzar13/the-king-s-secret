extends Control

@onready var key_label = $VBoxContainer/Vigenere/SecretKey
@onready var plaintext_label = $"VBoxContainer/Vigenere/plaintext"
@onready var ciphertext_label = $"VBoxContainer/Vigenere/ciphertext"
@onready var hint = $"VBoxContainer/Vigenere/Hint"

var secret_key = Globals.vigenere_key
var ciphertext = Globals.vigenere(Globals.message, secret_key, true)

func _ready() -> void:
	ciphertext_label.text = ciphertext
	plaintext_label.text = ciphertext
	key_label.text = "KEY: No Key Entered Yet"
	hint.get_popup().add_item("The King's favourite execution method")

# TODO visualization for shifting letters

func _on_key_text_text_submitted(new_text: String) -> void:
	key_label.text = "KEY: %s" % new_text
	plaintext_label.text = Globals.vigenere(ciphertext, new_text.to_upper(), false)
