extends Node
class_name Level

@export_category("Level Info")

@export var title : String
@export_multiline var description : String
@export_multiline var hint : String

@export_category("References")

# A level always has two castles: one creates messages, the other receives them
@export var starting_castle : Node2D
@export var ending_castle : Node2D

# A level has enemies already placed inside it, preferrably in the enemy area(s)
@export var enemies : Array[Enemy]

# A level has areas where the enemy resides
@export var enemy_areas : Area2D

# A level needs a reference to the path between the two castles
@export var path : Path2D

# A reference to the Messenger object (to spawn it)
var obj_messenger : PackedScene = preload("res://scenes/messenger.tscn")
var obj_tower : PackedScene = preload("res://scenes/tower.tscn")

var pending_build_on_click : Tower

func _ready() -> void:
	Globals.update_path.connect(update_path)
	Globals.building_action_ready.connect(prepare_to_place_tower)
	
	update_path()
	
	await get_tree().create_timer(0.5).timeout
	
	Globals.send_popup.emit(title, description)

func _physics_process(delta: float) -> void:
	if pending_build_on_click:
		pending_build_on_click.position = get_viewport().get_mouse_position()
		
	if Input.is_action_just_pressed("Draw"):
		if pending_build_on_click:
			pending_build_on_click.set_tower_state(Tower.TowerState.BUILT)
			pending_build_on_click = null
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
	
	obj.set_tower_state(Tower.TowerState.PREVIEW)
	pending_build_on_click = obj
	add_child(obj)

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
