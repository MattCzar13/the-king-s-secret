extends Control

@onready var key_label = $VBoxContainer/Vigenere/SecretKey
@onready var plaintext_label = $"VBoxContainer/Vigenere/plaintext"
@onready var ciphertext_label = $"VBoxContainer/Vigenere/ciphertext"
@onready var hint = $"VBoxContainer/Vigenere/Hint"

#NOTE: Vigenere only works with upper case key - quirk of using unicode I think
var secret_key = "Default".to_upper()
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

func _on_key_text_text_changed(new_text: String) -> void:
	key_label.text = "KEY: %s" % new_text
	plaintext_label.text = Globals.vigenere(ciphertext, new_text.to_upper(), false)

func _on_submit_button_pressed() -> void:
	if(secret_key.to_upper() == $"VBoxContainer/Vigenere/KeyText".text.to_upper()):
		attempt_fire_signal("minigame_success")
	else:
		attempt_fire_signal("minigame_fail")

func set_secret_key(key: String):
	#sets the seccret key and updates the cypher text
	secret_key = key.to_upper()
	ciphertext = Globals.vigenere(Globals.message, secret_key, true)
	
	
# Helper function to fire the signal and handle an error
func attempt_fire_signal(signal_name : String):
	var result : Error = Globals.emit_signal(signal_name)
	if result:
		printerr("Either this signal isn't connected to anything, or it is missing arguments!")
