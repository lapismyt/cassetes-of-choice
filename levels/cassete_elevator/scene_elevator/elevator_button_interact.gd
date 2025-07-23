extends InteractableBody3D

@export var btn_animator: AnimationPlayer
@export var door_animator: AnimationPlayer
@export var btn_animation_name: StringName = ""
@export var press_sound: AudioStreamMP3 = preload("res://base/sound/sfx/btn_press_pipe.mp3")
@export var sound_player: AudioStreamPlayer3D


func _ready() -> void:
	if btn_animator == null:
		btn_animator = %ElevatorBtnAnimator

	if door_animator == null:
		door_animator = null

	if sound_player == null:
		sound_player = %ElevatorSoundPlayer

	if btn_animation_name == &"":
		btn_animation_name = name

	# Поиск аниматора дверей лифта
	if door_animator == null:
		door_animator = get_tree().root.get_node(
			"GameManager/ElevatorScene/elevator_model/ElevatorDoorAnimator"
		)

	init_interactions()


func _exit_tree() -> void:
	close_interactions()


func on_interaction() -> void:
	if not check_door_animation():
		return
	if not play_press_animation():
		return
	play_sound()
	switch_elevator_state()


func check_door_animation() -> bool:
	if door_animator.is_playing():
		return false
	return true


func switch_elevator_state() -> void:
	if DataStoreElevator.elevator_open:
		door_animator.play("animation_close")
	else:
		door_animator.play("animation_close", -1, -1.2, true)

	DataStoreElevator.elevator_open = not DataStoreElevator.elevator_open

	print("Elevator state: ", "open" if DataStoreElevator.elevator_open else "closed")


func play_sound() -> void:
	if press_sound and sound_player:
		sound_player.stream = press_sound
		sound_player.play()


func play_press_animation() -> bool:
	if btn_animator and btn_animation_name:
		if btn_animator.has_animation(btn_animation_name):
			if btn_animator.current_animation == "":
				btn_animator.play(btn_animation_name, -1.0, 2.0)
				return true
		else:
			push_error("Animation '%s' not found" % btn_animation_name)
			print(btn_animator.get_animation_list())
	return false
