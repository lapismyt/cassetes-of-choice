extends Node

# sfx
@export var elevator_open_sound: AudioStream
@export var elevator_close_sound: AudioStream
@export
var elevator_button_press_sound: AudioStreamMP3 = preload("res://base/sound/sfx/btn_press_pipe.mp3")
@export var elevator_start_sound: AudioStream

# node_scenes
@export
var self_destroy_audio_player: PackedScene = preload("res://base/self_destroy_audio_player.tscn")

# scenes
@export var player_scene: PackedScene
@export var elevator_scene: PackedScene = preload(
	"res://levels/cassete_elevator/scene_elevator/elevator.tscn"
)
@export var elevator_void_station: PackedScene = preload(
	"res://levels/cassete_elevator/void_station/void_station.tscn"
)

# materials
@export var outline_material: ShaderMaterial = preload("res://outline.tres")
