extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = 980

func _ready():
	## Load but hide the pause menu on scene load
	$Camera2D/PauseMenu.hide()

func _physics_process(delta: float):
	#3 Display pause menu and pause the game
	if Input.is_action_just_pressed("menu"):
		get_tree().paused = true
		$Camera2D/PauseMenu.show()
		$Camera2D/PauseMenu/ResumeButton.grab_focus()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and $UnpauseTimer.is_stopped():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Handle vine mechanic
	if Input.is_action_pressed("vine"):
		velocity.x = velocity.x/2
		# TODO: Prevent wind from interacting with player
		# TODO: Play vine animation

	move_and_slide()


func _on_pause_menu_resume_signal():
	## Unpause the game and set a timer to prevent the unpause button from jumping
	get_tree().paused = false
	$Camera2D/PauseMenu.release_focus()
	$Camera2D/PauseMenu.hide()
	$UnpauseTimer.start()

func _on_pause_menu_quit_signal():
	## Unpause the game in case the player reloads it from main menu
	get_tree().paused = false
	$Camera2D/PauseMenu.release_focus()
	$Camera2D/PauseMenu.hide()
	$UnpauseTimer.start()
	
	## Switch back to main menu
	var old_level = get_tree().current_scene # Prepare to unload prior level
	old_level.queue_free() # Unload prior level 
	
	var level_instance = load("res://main.tscn").instantiate() # Load & instantiate main menu
	get_tree().root.add_child(level_instance) # Add main menu as a child of the root tree
	get_tree().set_current_scene.call_deferred(level_instance) # Set main menu as the new scene
