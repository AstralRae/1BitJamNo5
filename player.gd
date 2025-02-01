extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export_category("Wind Settings")
@export var WIND_SPEED = 275.0
@export var WIND_ANGLE = 45.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	# Switched from "is_action_pressed" to handle wind inconsistencies.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	velocity = _apply_wind(velocity, delta)

	move_and_slide()

func _apply_wind(velocity: Vector2, delta: float) -> Vector2:
	var angleInRadians = WIND_ANGLE * (PI / 180)
	
	velocity.x = velocity.x + (WIND_SPEED * cos(angleInRadians))
	# make sure we apply the same delta we apply to the gravity
	velocity.y = velocity.y + (WIND_SPEED * sin(angleInRadians) * delta)
	
	return velocity
