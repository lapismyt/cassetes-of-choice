extends Node


var main_scene_path: String
var main_scene_packed: PackedScene
var main_scene_instance: Node

const START_SCENE_PATH: String = "res://levels/scene_elevator/elevator.tscn"

const PAUSE_MENU_PATH: String = "res://base/pause_menu.tscn"
var pause_menu_packed: PackedScene = preload(PAUSE_MENU_PATH)
var pause_menu_instance: PauseMenu

var paused: bool = false


func _ready() -> void:
	pause_menu_instance = pause_menu_packed.instantiate()
	set_main_scene(START_SCENE_PATH)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func set_main_scene(path: String):
	main_scene_path = path
	main_scene_packed = load(path)
	var new_scene_instance: Node = main_scene_packed.instantiate()
	add_child(new_scene_instance)
	if main_scene_instance != null:
		main_scene_instance.queue_free()
	main_scene_instance = new_scene_instance


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		main_scene_instance.paused = not main_scene_instance.paused
		pause_menu_instance.visible = not pause_menu_instance.visible
		paused = not paused
		
		print_debug("pause")
		
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
