extends Control

signal resume_signal
signal quit_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_resume_button_button_down():
	resume_signal.emit()

func _on_menu_button_button_down():
	quit_signal.emit()
