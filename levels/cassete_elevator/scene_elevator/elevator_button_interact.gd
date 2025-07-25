class_name ElevatorButtonInteractable
extends InteractableBody3D

@export var btn_animator: AnimationPlayer
@export var btn_animation_name: StringName = &""
@export var press_sound: AudioStreamMP3 = ResourceManager.elevator_button_press_sound
@export var sound_player: AudioStreamPlayer3D


func _ready() -> void:
	if btn_animator == null:
		btn_animator = find_child("BtnAnimator")

	if sound_player == null:
		sound_player = %ElevatorSoundPlayer

	if btn_animation_name == &"":
		btn_animation_name = name

	init_interactions()


func _exit_tree() -> void:
	close_interactions()


func on_interaction() -> void:
	print_debug("try interact")
	if not play_press_animation():
		return
	play_sound()
	if has_method("elevator_button_interaction"):
		call("elevator_button_interaction")


func check_transition() -> bool:
	return not DataStoreElevator.elevator_in_transition


func play_sound() -> void:
	if press_sound and sound_player:
		sound_player.stream = press_sound
		sound_player.play()


func play_press_animation() -> bool:
	if btn_animator and btn_animation_name:
		if btn_animator.has_animation(btn_animation_name):
			if btn_animator.current_animation == "":
				btn_animator.play(btn_animation_name, -1.0, 1.0)
				return true
		else:
			push_error("Animation '%s' not found" % btn_animation_name)
			print(btn_animator.get_animation_list())
	return false
