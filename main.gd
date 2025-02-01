extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func switch_level(new_level): # Pass the filename of the new level with no extension as an argument
	var old_level = get_tree().current_scene # Prepare to unload prior level
	old_level.queue_free() # Unload prior level 
	
	var level_instance = load("res://" + new_level + ".tscn").instantiate() # Load & instantiate
	get_tree().root.add_child(level_instance) # Add the new level as a child of the root tree
	get_tree().set_current_scene(level_instance) # Set the current scene as the new level
