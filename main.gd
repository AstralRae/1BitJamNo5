extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Credits.hide()
	$Level1.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN) # Disable mouse for the whole game


func _on_menu_start_signal() -> void:
	$Menu.hide()
	$Level1.show()

func _on_menu_credit_signal():
	$Menu.hide()
	$Credits.show()
	$Credits/MenuButton.grab_focus()

func _on_credits_menu_signal():
	$Credits.hide()
	$Menu.show()
	$Menu/StartButton.grab_focus()
