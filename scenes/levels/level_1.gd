extends Node
class_name Level

# A level always has two castles: one creates messages, the other receives them
@export var starting_castle : Node2D
@export var ending_castle : Node2D

# A level always has at least one spawn point for enemies
@export var enemy_spawn_points : Array[Node2D]

# A level needs a reference to the path between the two castles
@export var path : Path2D

func _ready() -> void:
	Globals.update_path.connect(update_path)
	
	update_path()

# Updates the path node to link the castles
func update_path():
	# Clear the path curve
	path.curve = Curve2D.new()
	# Start the curve with the starting castle location
	path.curve.add_point(starting_castle.position)
	
	# TODO: Use towers as intermediate points
	
	# End the curve with the ending castle location
	path.curve.add_point(ending_castle.position)
