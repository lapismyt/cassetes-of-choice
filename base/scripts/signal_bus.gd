# Автозагружаемый синглтон для глобальных сигналов
extends Node

signal interaction_started(interactable)
signal interaction_completed(interactable)
signal hover_ended(interactable)
signal hover_started(interactable)

static var instance: SignalBus

func _ready() -> void:
	instance = self
