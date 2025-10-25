extends Node
class_name Level

# A level always has two castles: one creates messages, the other receives them
@export var starting_castle : Node2D
@export var ending_castle : Node2D

# A level always has at least one spawn point for enemies
@export var enemy_spawn_points : Array[Node2D]

# A level needs a reference to the path between the two castles
@export var path : Path2D

# A reference to the Messenger object (to spawn it)
var obj_messenger : PackedScene = preload("res://scenes/messenger.tscn")
var obj_tower : PackedScene = preload("res://scenes/tower.tscn")

var build_on_click : Node

func _ready() -> void:
	Globals.update_path.connect(update_path)
	Globals.building_action_ready.connect(prepare_to_place_tower)
	
	update_path()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Draw"):
		if build_on_click:
			build_on_click.position = get_viewport().get_mouse_position()
			add_child(build_on_click)
			build_on_click = null
			Globals.building_action_done.emit()
			update_path()

func prepare_to_place_tower(type : String):
	var obj : Tower = obj_tower.instantiate()
	
	match type:
		"Caesar Encrypt":
			obj.type = "Caesar Encrypt"
		"Caesar Decrypt":
			obj.type = "Caesar Decrypt"
		_:
			pass
	
	build_on_click = obj

# Updates the path node to link the castles
func update_path():
	# Clear the path curve
	path.curve = Curve2D.new()
	# Start the curve with the starting castle location
	path.curve.add_point(starting_castle.position)
	
	# Get a list of all towers in the scene
	var towers : Array[Node] = get_tree().get_nodes_in_group("Tower")
	# Sort them by left-right
	for tower in towers:
		if tower is not Tower:
			printerr("A non-tower node was assigned to the Tower group! This is bad!")
	towers.sort_custom(sort_position)
	# Add their positions to the list of points in that order
	for tower in towers:
		if tower.is_queued_for_deletion():
			continue
		
		path.curve.add_point(tower.position)
	
	# End the curve with the ending castle location
	path.curve.add_point(ending_castle.position)

func sort_position(a : Node2D, b : Node2D):
	if a.position.x < b.position.x:
		return true
	return false

# Spawns a messenger on a timer
func _on_messenger_spawn_timer_timeout() -> void:
	spawn_messenger()

# Spawns a messenger at the starting castle
func spawn_messenger():
	var obj : Messenger = obj_messenger.instantiate()
	obj.message = Globals.message
	path.add_child(obj)
