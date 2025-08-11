extends Node

# tiggers
signal change_elevator_station_sig(station: PackedScene)
signal elevator_open_doors
signal elevator_close_doors
signal resume_button_pressed
signal quit_button_pressed
signal add_player_sound(sound: AudioStream)
signal add_debug_label(label: String, id: StringName)
signal update_debug_label(label: String, id: StringName)
signal remove_debug_label(id: StringName)

# notifications
signal interaction_started(interactable: InteractableBody3D)
signal interaction_completed(interactable: InteractableBody3D)
signal interact_hover_ended(interactable: InteractableBody3D)
signal interact_hover_started(interactable: InteractableBody3D)
signal elevator_transition_started
signal elevator_transition_completed
signal paused
signal resumed
signal crouch_start(player: PlayerBody)
signal crouch_stop(player: PlayerBody)
signal debug_mode_toggled(debug_mode: bool)
signal doors_closed

static var instance: SignalBus


func _ready() -> void:
	instance = self
