class_name PauseMenu
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("resume"):
		SignalBus.resume_button_pressed.emit()


func _on_resume_button_pressed() -> void:
	SignalBus.resume_button_pressed.emit()


func _on_quit_button_pressed() -> void:
	SignalBus.quit_button_pressed.emit()
