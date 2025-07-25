extends AudioStreamPlayer3D


func _ready() -> void:
	SignalBus.elevator_transition_started.connect(start_transition_sounds)
	SignalBus.elevator_transition_completed.connect(stop_transition_sounds)


func start_transition_sounds() -> void:
	if ResourceManager.elevator_start_sound != null:
		stream = ResourceManager.elevator_start_sound
		play()


func stop_transition_sounds() -> void:
	stop()
