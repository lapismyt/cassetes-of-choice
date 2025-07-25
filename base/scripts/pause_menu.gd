class_name PauseMenu
extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("resume"):
		SignalBus.resume_button_pressed.emit()


func _on_resume_button_pressed() -> void:
	SignalBus.resume_button_pressed.emit()


func _on_quit_button_pressed() -> void:
	SignalBus.quit_button_pressed.emit()
