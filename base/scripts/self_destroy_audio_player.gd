class_name SelfDestroyAudioPlayer
extends AudioStreamPlayer3D


func _ready() -> void:
	finished.connect(queue_free)
