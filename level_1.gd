extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# TODO: Play Level 1 music

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
	
func _on_killzone_area_entered(area: Area2D):
	# TODO: Play death noise
	reset_level()
	
func reset_level():
	$Player.position = $PlayerSpawn.position
	# TODO: Reset wind/obstacles/enemies/etc.
