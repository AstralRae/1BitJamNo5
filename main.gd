extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$Credits.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN) # Disable mouse for the whole game

func switch_level(new_level): # Pass the filename of the new level with no extension as an argument
	var old_level = get_tree().current_scene # Prepare to unload prior level
	old_level.queue_free() # Unload prior level 
	
	var level_instance = load("res://" + new_level + ".tscn").instantiate() # Load & instantiate
	get_tree().root.add_child(level_instance) # Add the new level as a child of the root tree
	get_tree().set_current_scene.call_deferred(level_instance) # Set the current scene as the new level

func _on_menu_start_signal() -> void:
	switch_level("level1")

func _on_menu_credit_signal():
	$Menu.hide()
	$Credits.show()
	$Credits/MenuButton.grab_focus()

func _on_credits_menu_signal():
	$Credits.hide()
	$Menu.show()
	$Menu/StartButton.grab_focus()
