class_name InteractableBody3D
extends CollisionObject3D

# Настройки
@export var interaction_cooldown: int = 500
@export var mesh_instance: MeshInstance3D = null
@export var hovered_material: Material = null

# Состояние
var is_hovered: bool = false
var last_interaction: int
var original_material: Material = null


func _enter_tree() -> void:
	init_interactions()


func _exit_tree() -> void:
	close_interactions()


func init_interactions() -> void:
	_load_mesh_instance()
	_load_materials()

	GlobalInteractionManager.register_interactable(self)


func close_interactions() -> void:
	GlobalInteractionManager.unregister_interactable(self)


func _load_mesh_instance() -> void:
	if mesh_instance == null:
		var mesh_instances: Array[Node] = find_children("*", "MeshInstance3D")
		if len(mesh_instances) > 0:
			mesh_instance = mesh_instances[0]
			if len(mesh_instances) > 1:
				push_warning("Found multiple MeshInstance3D")
			return
		push_error("Child MeshInstance3D not found")


func _load_materials() -> void:
	if mesh_instance:
		original_material = mesh_instance.mesh.surface_get_material(0)

		if hovered_material == null:
			hovered_material = original_material.duplicate()
			var outline = ResourceManager.outline_material
			if outline:
				hovered_material.next_pass = outline


func handle_hover_start() -> void:
	if is_hovered:
		return
	is_hovered = true

	if mesh_instance and hovered_material:
		mesh_instance.mesh.surface_set_material(0, hovered_material)

	SignalBus.interact_hover_started.emit(self)


func handle_hover_end() -> void:
	if not is_hovered:
		return
	is_hovered = false

	if mesh_instance and original_material:
		mesh_instance.mesh.surface_set_material(0, original_material)

	SignalBus.interact_hover_ended.emit(self)


func handle_interaction() -> void:
	last_interaction = Time.get_ticks_msec()
	SignalBus.emit_signal("interaction_started", self)

	if has_method("on_interaction"):
		call("on_interaction")


func can_interact() -> bool:
	print("===========")
	print_debug(last_interaction)
	print_debug(Time.get_ticks_msec())
	print_debug(interaction_cooldown)
	print_debug(
		(
			last_interaction == null
			or (Time.get_ticks_msec() - last_interaction) >= interaction_cooldown
		)
	)
	return (
		last_interaction == null
		or (Time.get_ticks_msec() - last_interaction) >= interaction_cooldown
	)
