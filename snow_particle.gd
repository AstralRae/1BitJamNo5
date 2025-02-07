extends RigidBody2D

@export var lifetime = 2.0
var timer = 0.0
@export_category("Wind")
@export var WIND_SPEED = 0.0
@export var WIND_ANGLE = 0.0
var originalVector = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Apply random initial velocity
	linear_velocity = Vector2(randf() * 200 - 100, randf() * 200 - 100)
	originalVector = linear_velocity
	name = "SnowParticle"
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if WIND_SPEED > 0:
		linear_velocity = Vector2(get_wind_x(), get_wind_y())
	else:
		linear_velocity = originalVector
	
	timer += delta
	if timer >= lifetime:
		queue_free()

func get_wind_x() -> float:
	var angleInRadians = WIND_ANGLE * (PI / 180)
	return WIND_SPEED * cos(angleInRadians)
	
func get_wind_y() -> float:
	var angleInRadians = WIND_ANGLE * (PI / 180)
	return WIND_SPEED * sin(angleInRadians)
