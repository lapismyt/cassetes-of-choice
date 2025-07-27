extends Node

var main_scene_path: String
var main_scene_packed: PackedScene
var main_scene_instance: Node

@export var debug_mode: bool = true

@export var start_scene_path: StringName = ResourceManager.start_scene_path

@export var pause_menu_packed: PackedScene = ResourceManager.pause_menu_scene
var pause_menu_instance: PauseMenu

@export var debug_menu_packed: PackedScene = ResourceManager.debug_menu_scene
var debug_menu_instance: DebugMenu

@export var pause_cooldown_time: float = 0.1
var pause_cooldown: bool = false
var is_paused: bool = false


func _ready() -> void:
	#pause_menu_instance = pause_menu_packed.instantiate()]
	if start_scene_path == null:
		print("No start scene path set")
	if debug_mode:
		enable_debug_menu()

	SignalBus.add_debug_label.emit("Main Scene: ???", "main_scene")
	set_main_scene(start_scene_path)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	SignalBus.resume_button_pressed.connect(hide_pause_menu)
	SignalBus.quit_button_pressed.connect(quit_game)


func set_debug_mode(enabled: bool) -> void:
	debug_mode = enabled
	SignalBus.debug_mode_toggled.emit(debug_mode)
	if debug_mode:
		enable_debug_menu()
	else:
		disable_debug_menu()


func enable_debug_menu() -> void:
	if debug_menu_instance == null:
		debug_menu_instance = debug_menu_packed.instantiate()
		add_child(debug_menu_instance)


func disable_debug_menu() -> void:
	if debug_menu_instance != null:
		debug_menu_instance.queue_free()
		debug_menu_instance = null


func set_main_scene(path: String):
	main_scene_path = path
	main_scene_packed = load(path)
	var new_scene_instance: Node = main_scene_packed.instantiate()
	add_child(new_scene_instance)
	move_child(new_scene_instance, 0)
	if main_scene_instance != null:
		main_scene_instance.queue_free()
	main_scene_instance = new_scene_instance
	SignalBus.update_debug_label.emit("Main Scene: " + main_scene_instance.name, "main_scene")


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
