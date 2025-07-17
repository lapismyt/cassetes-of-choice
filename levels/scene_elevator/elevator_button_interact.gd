extends InteractableBody3D


@export var animation_player: AnimationPlayer
@export var animation_name: String = name
@export var press_sound: AudioStreamMP3 = preload("res://base/sound/sfx/btn_press_pipe.mp3")
@export var sound_player: AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print_debug("_ready() called")
	if animation_player == null:
		animation_player = %AnimationPlayer
	init_interactions()
	interacted.connect(on_interact)
	if sound_player == null:
		sound_player = %ElevatorSoundPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_interact() -> void:
	play_press_animation() 
	play_sound()


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
