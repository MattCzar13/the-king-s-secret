extends PathFollow2D
class_name Messenger

# Messenger object
# This is a PathFollow2D, which means we can very easily move it
# along a Path2D as long as it is a child of one

# The message that this messenger carries
var message : String = ""

signal message_delivered(message : String)

func _physics_process(delta: float) -> void:
	# Once the messenger arrives at the end of the path...
	if is_equal_approx(progress_ratio, 1.0):
		message_delivered.emit(message)
		queue_free()
	
	progress += 100 * delta
