class_name DebugMenu
extends CanvasLayer

var main_container: VBoxContainer
var blinding_effect_instance: Node = null
var blinding_effect_scene = preload("res://base/blinding_effect.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_container = find_child("MainContainer")

	SignalBus.add_debug_label.connect(add_debug_label)
	SignalBus.update_debug_label.connect(update_debug_label)
	SignalBus.remove_debug_label.connect(remove_debug_label)


func add_debug_label(label: String, id: String) -> void:
	var label_node: Label = Label.new()
	label_node.label_settings = LabelSettings.new()
	label_node.label_settings.font_size = 22
	label_node.text = label
	label_node.name = id
	main_container.add_child(label_node)
	print_debug(label_node)


func update_debug_label(label: String, id: String) -> void:
	var label_node: Label = main_container.find_child(id, false, false)
	print_debug(id)
	if label_node != null:
		label_node.text = label
	print_debug(label_node)


func remove_debug_label(id: String) -> void:
	var label_node: Label = main_container.find_child(id, false, false)
	label_node.queue_free()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("debug_actions") and Input.is_action_just_pressed("debug1"):
		print_debug("Debug Action 1 pressed")
		if blinding_effect_instance != null:
			blinding_effect_instance.kill_tween()
			blinding_effect_instance.queue_free()
			blinding_effect_instance = null
		blinding_effect_instance = blinding_effect_scene.instantiate()
		add_child(blinding_effect_instance)
		blinding_effect_instance.blind_finished.connect(_on_blinding_effect_finished)
		blinding_effect_instance.start_blinding()


func _on_blinding_effect_finished() -> void:
	if blinding_effect_instance != null:
		blinding_effect_instance.unblind_finished.connect(_on_unblinding_effect_finished)
		blinding_effect_instance.start_unblinding()


func _on_unblinding_effect_finished() -> void:
	if blinding_effect_instance != null:
		blinding_effect_instance.queue_free()
		blinding_effect_instance = null
