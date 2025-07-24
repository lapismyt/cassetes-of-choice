extends Node3D

var current_station: PackedScene
var is_in_transition: bool = false
var transition_timer: float = 0.0
@export var transition_duration: float = 0.5
@export var transition_sound: AudioStream

func change_station(station: PackedScene) -> void:
    current_station = station
    is_in_transition = true


func _ready() -> void:
    pass


func _process(delta: float) -> void:
    pass