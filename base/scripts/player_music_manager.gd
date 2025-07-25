extends Node3D

var sound_players: Array[AudioStreamPlayer3D] = []


func _ready() -> void:
	SignalBus.add_player_sound.connect(_add_player_sound)


func _add_player_sound(sound: AudioStream) -> void:
	var audio_player_instance: SelfDestroyAudioPlayer = (
		ResourceManager.self_destroy_audio_player.instantiate()
	)
	audio_player_instance.stream = sound
	sound_players.append(audio_player_instance)
	add_child(audio_player_instance)
	audio_player_instance.play()
