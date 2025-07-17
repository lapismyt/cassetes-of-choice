extends MeshInstance3D

# Ссылка на AnimationPlayer (если анимации в другом узле)
@export var animation_player: AnimationPlayer
# Имя анимации, которую нужно проиграть
@export var animation_name: String = name

func _ready():
	# Включаем обработку ввода для этого меша
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Проверяем, кликнули ли на этот объект
		var camera = get_viewport().get_camera_3d()
		var ray_length = 1000
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		
		if result.has("collider") and result["collider"] == self:
			interact()

func interact():
	print_debug("Взаимодействие с: ", name)
	
	# Воспроизводим анимацию, если есть AnimationPlayer и имя анимации
	if animation_player and animation_name:
		if animation_player.has_animation(animation_name):
			animation_player.play(animation_name)
		else:
			print_debug("Анимация '", animation_name, "' не найдена")
	
	# Здесь можно добавить другие действия
