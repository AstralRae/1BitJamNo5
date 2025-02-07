extends Node2D

var Popup1 = false
var Popup2 = false
var Popup3 = false
var Popup4 = false
var Popup5 = false
var Check1 = false
var Check2 = false
var death_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.publicReset.call()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
	
func _on_killzone_area_entered(area: Area2D):
	$DeathNoise.play()
	reset_level()
	
func reset_level():
	$Player.position = $PlayerSpawn.position
	$Player.publicReset.call()
	death_count += 1
	
func _on_wind_area_entered(area: Area2D, new_wind_speed: float, new_wind_angle: float):
	$Player.WIND_SPEED = new_wind_speed
	$Player.WIND_ANGLE = new_wind_angle
	return
	
func _on_wind_area_exited(area: Area2D):
	$Player.publicWindReset.call()

func _on_first_popup_area_entered(area: Area2D):
	$FirstPopup/Label.show()
	if Popup1 == false:
		$PopupNoise.play()
		$SpeedrunTimer.start()
		Popup1 = true

func _on_first_popup_area_exited(area: Area2D):
	$FirstPopup/Label.hide()

func _on_second_popup_area_entered(area: Area2D):
	$SecondPopup/Label.show()
	if Popup2 == false:
		$PopupNoise.play()
		Popup2 = true

func _on_second_popup_area_exited(area: Area2D):
	$SecondPopup/Label.hide()

func _on_third_popup_area_entered(area: Area2D):
	$ThirdPopup/Label.show()
	if Popup3 == false:
		$PopupNoise.play()
		Popup3 = true
	
func _on_third_popup_area_exited(area: Area2D):
	$ThirdPopup/Label.hide()

func _on_fourth_popup_area_entered(area: Area2D):
	$FourthPopup/Label.show()
	if Popup4 == false:
		$PopupNoise.play()
		Popup4 = true

func _on_fourth_popup_area_exited(area: Area2D):
	$FourthPopup/Label.hide()
	


func _on_first_checkpoint_area_entered(area: Area2D):
	if Check1 == false:
		$PlayerSpawn.position = $FirstCheckpoint/Marker2D.position
		$FirstCheckpoint/Label.show()
		$CheckpointNoise.play()
		$FirstCheckpoint/AnimatedSprite2D.play()
		Check1 = true

func _on_first_checkpoint_area_exited(area: Area2D):
	$FirstCheckpoint/Label.hide()


func _on_second_checkpoint_area_entered(area: Area2D) -> void:
	if Check2 == false:
		$PlayerSpawn.position = $SecondCheckpoint/Marker2D.position
		$SecondCheckpoint/Label.show()
		$CheckpointNoise.play()
		$SecondCheckpoint/AnimatedSprite2D.play()
		Check2 = true

func _on_second_checkpoint_area_exited(area: Area2D) -> void:
	$SecondCheckpoint/Label.hide()

func _on_wind_body_entered(body: Node2D, new_wind_speed: float, new_wind_angle: float) -> void:
	if body.name == "Player" or body.name.begins_with("SnowParticle"):
		body.WIND_SPEED = new_wind_speed
		body.WIND_ANGLE = new_wind_angle
		
func _on_wind_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Player.publicWindReset.call()
		return
	if body.name.begins_with("SnowParticle"):
		body.WIND_SPEED = 0 # this will reset the particle to its previous velocity value
		return


func _on_fifth_popup_area_entered(area: Area2D):
	$FifthPopup/Label.show()
	if Popup5 == false:
		$PopupNoise.play()
		Popup5 = true


func _on_fifth_popup_area_exited(area: Area2D):
	$FifthPopup/Label.hide()

func _on_last_popup_area_entered(area: Area2D):
	$LastPopup/Label.show()
	$LastPopup/TimeLabel.show()
	var time_spent = $SpeedrunTimer.wait_time - $SpeedrunTimer.time_left
	$LastPopup/TimeLabel.text = "Time: %.2f" % time_spent
	$LastPopup/DeathLabel.show()
	$LastPopup/DeathLabel.text = "Deaths: " + str(death_count)
	$LastPopup/ChallengeLabel.show()
	$SpeedrunTimer.stop()
