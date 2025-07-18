class_name PlayerBody
extends CharacterBody3D

@export var speed = 5.0
@export var jump_force = 4.5
@export var mouse_sensitivity = 0.002
@export var crouch_speed = 2.5  # Скорость при приседании
@export var standing_height = 1.8  # Нормальная высота
@export var crouching_height = 1.0  # Высота при приседании

@export var firstPerson = true


var gravity = 9.8
var is_crouching = false
var normal_speed = speed

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	normal_speed = speed  # Инициализируем нормальную скорость

func _input(event):

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$fpCamera.rotate_x(-event.relative.y * mouse_sensitivity)
		$fpCamera.rotation.x = clamp($fpCamera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	# Обработка приседания
	handle_crouch()
	
	# Движение
	var current_speed = crouch_speed if is_crouching else speed
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	# Гравитация и прыжок
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump") and not is_crouching:
			velocity.y = jump_force

	move_and_slide()

func handle_crouch():
	if Input.is_action_just_pressed("sneak"):
		print_debug("sneak pressed")
	if Input.is_action_pressed("sneak") and not is_crouching:
		# Начинаем приседать
		is_crouching = true
		$fpCamera.position.y = lerp(crouching_height,0.1,0.2)
		$CollisionShape3D.shape.height = crouching_height * 0.9  # Уменьшаем коллизию
		
	elif not Input.is_action_pressed("sneak") and is_crouching:
		# Встаем только если над головой есть место
		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(
			global_position,
			global_position + Vector3.UP * standing_height
		)
		var result = space.intersect_ray(query)
		
		if not result:
			is_crouching = false
			$fpCamera.position.y = standing_height
			$CollisionShape3D.shape.height = standing_height * 0.9  # Восстанавливаем коллизию
