extends Control

signal menu_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_menu_button_button_down():
	menu_signal.emit()
