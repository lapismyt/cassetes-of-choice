class_name PlayerBody
extends CharacterBody3D

@export var speed = 5.0
@export var jump_force = 4.5
@export var mouse_sensitivity = 0.002
@export var crouch_speed = 2.5  # Скорость при приседании
@export var standing_height = 1.8  # Нормальная высота
@export var crouching_height = 0.9  # Высота при приседании

@export var firstPerson = true

var gravity = 9.8
var is_crouching = false
var normal_speed = speed

@export var fp_camera: Camera3D
@export var collision: CollisionShape3D


func _ready():
	normal_speed = speed

	if fp_camera == null:
		fp_camera = find_child("fpCamera")

	if collision == null:
		collision = find_child("CollisionShape3D")


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		fp_camera.rotate_x(-event.relative.y * mouse_sensitivity)
		fp_camera.rotation.x = clamp(fp_camera.rotation.x, -PI / 2, PI / 2)


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
	# if Input.is_action_just_pressed("sneak"):
	# 	print_debug("sneak pressed")
	if Input.is_action_pressed("sneak") and not is_crouching:
		is_crouching = true
		fp_camera.position.y = lerp(standing_height, crouching_height, 0.2)
		collision.shape.height = crouching_height * 0.9  # Уменьшаем коллизию
		apply_floor_snap()
		SignalBus.crouch_start.emit(self)

	elif not Input.is_action_pressed("sneak") and is_crouching:
		var space = get_world_3d().direct_space_state
		var from = global_position
		from.y = from.y + standing_height / 2
		var query = PhysicsRayQueryParameters3D.create(
			from, global_position + Vector3.UP * standing_height
		)
		var result = space.intersect_ray(query)

		# print_debug(result)

		if not result:
			is_crouching = false
			fp_camera.position.y = standing_height
			collision.shape.height = standing_height * 0.9  # Восстанавливаем коллизию

		SignalBus.crouch_stop.emit(self)
