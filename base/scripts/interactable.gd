class_name InteractableBody3D
extends CollisionObject3D


signal interacted()
signal hovered()


@export var interaction_distance: float = 1000.0
@export var mesh_instance: MeshInstance3D = null
var original_material: Material = null
@export var hovered_material: Material = null
@export var interact_cooldown: float = 0.8
var since_last_interaction: float = -1
var is_hovered: bool = false
var is_ready: bool = false


func load_mesh_instance() -> void:
	#print_debug("Loading MeshInstance3D")
	if mesh_instance == null:
		var children: Array[Node] = get_children()
		#print_debug(children)
		var name_lower: String = name.to_lower()
		var accept_names: Array[String] = [name_lower, name_lower+"_mesh"]
		
		for child in children:
			if not child.name.to_lower() in accept_names:
				#print_debug("name declined: ", child.name.to_lower())
				continue
			if not child.is_class("MeshInstance3D"):
				#print_debug("class: ", child.get_class())
				push_warning("Found child node with "+child.name+ \
					" in "+name+" but it's not MeshInstance3D")
				continue
				
			mesh_instance = child
			break
		
		if mesh_instance == null:
			push_error("MeshInstance3D not found for "+name)
	
	#print_debug(load("res://outline.tres").get_class())


func load_materials() -> void:
	#print_debug("Loading original and hovered materials")
	
	if original_material == null:
		original_material = mesh_instance.mesh.surface_get_material(0)
		
	if hovered_material == null:
		hovered_material = original_material.duplicate()
		hovered_material.next_pass = load("res://outline.tres")
	
	
func _ready() -> void:
	init_interactions()


func init_interactions() -> void:
	#print_debug("init() called")
	load_mesh_instance()
	load_materials()
	set_process_input(true)
	is_ready = true
	#print_debug("Ready")


func update_hovering() -> void:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var cam: Camera3D = get_viewport().get_camera_3d()
	var mousepos: Vector2 = get_viewport().get_mouse_position()
	
	var origin: Vector3 = cam.project_ray_origin(mousepos)
	var end: Vector3 = origin + cam.project_ray_normal(mousepos) * interaction_distance
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	
	var result: Dictionary = space_state.intersect_ray(query)
	#print_debug(result)
	
	if result.is_empty():
		return
	
	var collider: Node = result["collider"]
	
	if collider == self:
		if not is_hovered:
			return _start_hover()
	else:
		if is_hovered:
			return _end_hover()


func _physics_process(delta: float) -> void:
	if is_ready:
		update_hovering()
	if since_last_interaction > interact_cooldown:
		return
	if since_last_interaction < 0:
		since_last_interaction = delta
	since_last_interaction += delta
	#print_debug("since last interaction: ", since_last_interaction)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		if is_hovered and (since_last_interaction < 0 or since_last_interaction > interact_cooldown):
			since_last_interaction = 0
			interacted.emit()
			print_debug("interacted")


func _start_hover() -> void:
	mesh_instance.mesh.surface_set_material(0, hovered_material)
	is_hovered = true
	hovered.emit()


func _end_hover() -> void:
	mesh_instance.mesh.surface_set_material(0, original_material)
	is_hovered = false


func _interact() -> void:
	pass
