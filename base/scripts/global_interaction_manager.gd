extends Node


signal interactable_hovered(interactable)
signal interactable_unhovered(interactable)
signal interaction_completed(interactable)


var hovered_object: InteractableBody3D = null
var interactables: Array[InteractableBody3D] = []

@export var interaction_distance: float = 5.0


func _process(_delta: float) -> void:
	var viewport = get_viewport()
	if not viewport: return
	
	var camera = viewport.get_camera_3d()
	if not camera: return
	
	# Выпускаем луч из центра экрана
	var mouse_pos = viewport.get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * interaction_distance
	
	var space_state = viewport.world_3d.direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	
	var new_hovered = null
	if result:
		var collider = result.collider
		if collider is InteractableBody3D and collider in interactables:
			new_hovered = collider
	
	if new_hovered != hovered_object:
		if hovered_object:
			hovered_object.handle_hover_end()
			emit_signal("interactable_unhovered", hovered_object)
		
		hovered_object = new_hovered
		
		if hovered_object:
			hovered_object.handle_hover_start()
			emit_signal("interactable_hovered", hovered_object)
	
	if Input.is_action_just_pressed("interact") and hovered_object:
		if hovered_object.can_interact():
			hovered_object.handle_interaction()
			emit_signal("interaction_completed", hovered_object)


func register_interactable(interactable: InteractableBody3D) -> void:
	if not interactable in interactables:
		interactables.append(interactable)


func unregister_interactable(interactable: InteractableBody3D) -> void:
	if interactable in interactables:
		interactables.erase(interactable)
		if hovered_object == interactable:
			hovered_object = null
