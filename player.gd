extends CharacterBody2D

@export_category("Movement")
# The below control walk speed
@export var WALK_ACCELERATION = 600.0 # This is how fast the character can accelerate per second
var default_WALK_ACCELERATION = 600.0
@export var MAX_WALK_SPEED = 300.0 # This is the character's max speed
const default_MAX_WALK_SPEED = 300.0
# If WALK_ACCELERATION and MAX_WALK_SPEED are equal then it takes 1 second to reach max speed
# IF WALK_ACCELERATION is higher then it takes less than a second
# IF WALK_ACCELERATION is lower then it takes more than a second

# The below control jump physics
@export var JUMP_POWER = -2000.0 # How strong is the jump
const default_JUMP_POWER = -2000.0
@export var MAX_JUMP_POWER = -400.0 # How much total jump can be applied
const default_MAX_JUMP_POWER = -400.0
# abs(JUMP_POWER) must be greater than the strength of gravity
# This is because gravity * delta is the downward force on the character
# So JUMP_POWER * delta must be greater
# MAX_JUMP_POWER controls how high the player can jump
# How long it takes to reach max jump is going to be MAX_JUMP_POWER / JUMP_POWER
# The longer it takes to reach max jump the easier it is to do a smaller jump
@export_category("Wind")
@export var WIND_SPEED = 0.0
const default_WIND_SPEED = 0
@export var WIND_ANGLE = 0.0
const default_WIND_ANGLE = 0
@export_category("Gravity")
@export var gravity = 980
const default_gravity = 980

# Expose the reset function so it can be called by the level's reset
@export var publicReset = func (): reset()

# If current_speed is positive the char is walking right, if negative the char is walking left
var current_speed = 0.0 
const default_current_speed = 0
var current_jump_velocity_applied = 0
const default_current_jump_velocity_applied = 0
var jump_released = true
const default_jump_released = true # Starts as true to prevent automatic jump on reset

func _ready():
	## Load but hide the pause menu on scene load
	$Camera2D/PauseMenu.hide()

func _physics_process(delta: float):
	# Display pause menu and pause the game
	if Input.is_action_just_pressed("menu"):
		get_tree().paused = true
		$Camera2D/PauseMenu.show()
		$Camera2D/PauseMenu/ResumeButton.grab_focus()
	
	# First we handle the vertical movement.
	
	# Get whether the jump button is pressed
	# Switched from "is_action_pressed" to handle varying jump height.
	var jumpPressed = Input.is_action_pressed("ui_accept")
	
	# Add the gravity.
	if not is_on_floor():
		var gravityVector = get_gravity() * delta
		gravityVector.y += get_wind_y() * delta
		velocity += gravityVector
		# If we're in the air but jump is not pressed then prevent repressing jump
		if !jumpPressed:
			jump_released = true
	else:
		# Handle hitting the floor
		current_jump_velocity_applied = 0
		jump_released = false

	# Handle jump.
	# If the button is pressed and hasn't been released
	if jumpPressed and !jump_released:
		var deltaY = JUMP_POWER * delta
		# If we haven't reached our max "applied jump" then apply more
		if current_jump_velocity_applied > MAX_JUMP_POWER:
			velocity.y += deltaY
			current_jump_velocity_applied += deltaY

	# Now we can handle horizontal movement

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var walkDirection := Input.get_axis("ui_left", "ui_right")
	var vinePressed := Input.is_action_pressed("vine")
	var windDeltaX = vinePressed if 0 else get_wind_x() # I don't like GDScript ternary operator
	if walkDirection:
		var deltaX = (walkDirection * WALK_ACCELERATION + windDeltaX) * delta
		if walkDirection > 0:
			velocity.x = minf(velocity.x + deltaX, MAX_WALK_SPEED + windDeltaX)
		if walkDirection < 0:
			velocity.x = maxf(velocity.x + deltaX, -MAX_WALK_SPEED + windDeltaX)
	else:
		velocity.x = move_toward(velocity.x, windDeltaX, WALK_ACCELERATION * delta)
		
	# Handle vine mechanic
	if vinePressed:
		velocity.x = velocity.x/2
		# TODO: Play vine animation

	move_and_slide()
	
func reset():
	# I wonder if there's a better way to do this
	WALK_ACCELERATION = default_WALK_ACCELERATION
	MAX_WALK_SPEED = default_MAX_WALK_SPEED
	JUMP_POWER = default_JUMP_POWER
	MAX_JUMP_POWER = default_MAX_JUMP_POWER
	WIND_ANGLE = default_WIND_ANGLE
	WIND_SPEED = default_WIND_SPEED
	gravity = default_gravity
	current_speed = default_current_speed
	current_jump_velocity_applied = default_current_jump_velocity_applied
	jump_released = default_jump_released

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

func get_wind_x() -> float:
	var angleInRadians = WIND_ANGLE * (PI / 180)
	return WIND_SPEED * cos(angleInRadians)
	
func get_wind_y() -> float:
	var angleInRadians = WIND_ANGLE * (PI / 180)
	return WIND_SPEED * sin(angleInRadians)
