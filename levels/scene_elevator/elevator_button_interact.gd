extends InteractableBody3D


@export var animation_player: AnimationPlayer
@export var animation_name: String = name
@export var press_sound: AudioStreamMP3 = preload("res://base/sound/sfx/btn_press_pipe.mp3")
@export var sound_player: AudioStreamPlayer3D
var elevator_open: bool = true
var elevator_anim_player: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print_debug("_ready() called")
	if animation_player == null:
		animation_player = %ElevatorBtnAnimator
	if sound_player == null:
		sound_player = %ElevatorSoundPlayer
	if elevator_anim_player == null:
		#get_tree().root.print_tree_pretty()
		elevator_anim_player = get_tree().root.get_node("GameManager/ElevatorScene/elevator_model/ElevatorDoorAnimator")

	interact_cooldown = 1.0

	init_interactions()
	interacted.connect(on_interact)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_interact() -> void:
	play_press_animation() 
	play_sound()
	switch_elevator()


func switch_elevator() -> void:
	if elevator_open:
		elevator_anim_player.play("animation_close")
		print_debug("elevator close")
	else:
		elevator_anim_player.play('animation_close',-1,-1,true)
		print_debug("elevator open")
	elevator_open = not elevator_open


func play_sound() -> void:
	#print_debug(press_sound.get_class())
	sound_player.stream = press_sound
	sound_player.play()


func play_press_animation() -> void:
	if animation_player and animation_name:
		if animation_player.has_animation(animation_name):
			if animation_player.current_animation == animation_name:
				animation_player.stop()
			animation_player.play(animation_name)
			return
		else:
			push_error("Animation \"", animation_name, "\" not found")
	else:
		push_warning("animation_player or animation_name is missing")
