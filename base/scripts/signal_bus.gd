# Автозагружаемый синглтон для глобальных сигналов
extends Node

signal interaction_started(interactable: InteractableBody3D)
signal interaction_completed(interactable: InteractableBody3D)
signal interact_hover_ended(interactable: InteractableBody3D)
signal interact_hover_started(interactable: InteractableBody3D)
signal resume_button_pressed
signal quit_button_pressed
signal paused
signal resumed

static var instance: SignalBus


func _ready() -> void:
	instance = self
