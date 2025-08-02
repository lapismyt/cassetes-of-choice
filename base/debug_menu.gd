class_name DebugMenu
extends Control

var main_container: VBoxContainer


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
