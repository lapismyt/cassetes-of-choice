extends InteractableBody3D

@export var btn_animator: AnimationPlayer
@export var door_animator: AnimationPlayer
@export var btn_animation_name: String = "button_0"
@export var press_sound: AudioStreamMP3 = preload("res://base/sound/sfx/btn_press_pipe.mp3")
@export var sound_player: AudioStreamPlayer3D

var elevator_open: bool = true


func _ready() -> void:
	if btn_animator == null:
		btn_animator = %ElevatorBtnAnimator
	
	if door_animator == null:
		door_animator = null
	
	if sound_player == null:
		sound_player = %ElevatorSoundPlayer
	
	# Поиск аниматора дверей лифта
	if door_animator == null:
		door_animator = get_tree().root.get_node("GameManager/ElevatorScene/elevator_model/ElevatorDoorAnimator")
	
	init_interactions()


func _exit_tree() -> void:
	close_interactions()


func on_interaction() -> void:
	play_press_animation() 
	play_sound()
	switch_elevator_state()


func switch_elevator_state() -> void:
	
	if elevator_open:
		door_animator.play("animation_close")
	else:
		door_animator.play('animation_close',-1,-1,true)
	
	elevator_open = not elevator_open
	print("Elevator state: ", "open" if elevator_open else "closed")


func play_sound() -> void:
	if press_sound and sound_player:
		sound_player.stream = press_sound
		sound_player.play()


func play_press_animation() -> void:
	if btn_animator and btn_animation_name:
		if btn_animator.has_animation(btn_animation_name):
			btn_animator.play(btn_animation_name)
		else:
			push_error("Animation '%s' not found" % btn_animation_name)
			print(btn_animator.get_animation_list())
