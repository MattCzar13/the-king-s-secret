extends Node2D
class_name Tower

# Tower object
# Serves as intermediate points for messages to pass through
# Detects colliding messengers, reads their message, and changes it accordingly
# The tower needs to be prepared through a minigame

# Change messengers's message (if the tower has been setup correctly)
func _on_area_2d_area_entered(area: Area2D) -> void:
	if !area.get_parent():
		return
	var messenger = area.get_parent()
	
	if messenger is Messenger:
		read_and_write(messenger)

func read_and_write(m : Messenger):
	# This is where the tower reads the message and changes it,
	# according to what type of tower this is.
	pass
