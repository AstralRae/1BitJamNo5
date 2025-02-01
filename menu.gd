extends Control

signal start_signal
signal credit_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_button_down():
	start_signal.emit()

func _on_credits_button_button_down():
	credit_signal.emit()
