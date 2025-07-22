extends Node


var main_scene_path: String
var main_scene_packed: PackedScene
var main_scene_instance: Node

@export var start_scene_path: StringName = "res://levels/scene_elevator/elevator.tscn"

@export var pause_menu_packed: PackedScene = preload("res://base/pause_menu.tscn")
var pause_menu_instance: PauseMenu

@export var pause_cooldown_time: float = 0.1
var pause_cooldown: bool = false
var is_paused: bool = false


func _ready() -> void:
	#pause_menu_instance = pause_menu_packed.instantiate()
	set_main_scene(start_scene_path)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	SignalBus.resume_button_pressed.connect(hide_pause_menu)
	SignalBus.quit_button_pressed.connect(quit_game)


func set_main_scene(path: String):
	main_scene_path = path
	main_scene_packed = load(path)
	var new_scene_instance: Node = main_scene_packed.instantiate()
	add_child(new_scene_instance)
	if main_scene_instance != null:
		main_scene_instance.queue_free()
	main_scene_instance = new_scene_instance


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		pause_cooldown = true
		await get_tree().create_timer(pause_cooldown_time).timeout
		pause_cooldown = false


func toggle_pause() -> void:
	is_paused = not is_paused
	
	if is_paused:
		show_pause_menu()
	else:
		hide_pause_menu()


func show_pause_menu() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if pause_menu_packed == null:
		return
	pause_menu_instance = pause_menu_packed.instantiate()
	add_child(pause_menu_instance)
	get_tree().paused = true
	SignalBus.paused.emit()


func hide_pause_menu() -> void:
	if pause_cooldown:
		return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if pause_menu_instance == null:
		return
	pause_menu_instance.queue_free()
	pause_menu_instance = null
	get_tree().paused = false
	SignalBus.resumed.emit()


func quit_game() -> void:
	get_tree().quit()


func _process(delta: float) -> void:
	pass
