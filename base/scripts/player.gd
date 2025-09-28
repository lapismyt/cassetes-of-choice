class_name PlayerBody
extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_force: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var crouch_speed: float = 2.5  # Скорость при приседании
@export var standing_height: float = 1.75  # Нормальная высота
@export var crouching_height: float = 1.0  # Высота при приседании

@export var firstPerson: bool = true

var gravity: float = 9.8
var is_crouching: bool = false
var normal_speed: float = speed
var is_walking: bool = false

@export var fp_camera: Camera3D
@export var collision: CollisionShape3D

@onready var animation_tree: AnimationTree = %PlayerAnimationTree
@onready
var anim_playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


func _ready():
	normal_speed = speed

	if fp_camera == null:
		fp_camera = find_child("fpCamera")

	if collision == null:
		collision = find_child("CollisionShape3D")

	animation_tree.active = true


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
	if input_dir.x != 0 or input_dir.y != 0:
		is_walking = true
	else:
		is_walking = false

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	# Гравитация и прыжок
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump") and not is_crouching:
			velocity.y = jump_force

	update_animation_state()
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


func update_animation_state():
	var target_animation: String = "player_idle"

	if velocity.x != 0 or velocity.z != 0:
		target_animation = "player_walk"
		# if Input.is_action_pressed("move_left"):
		# 	target_animation = "turn_left"
		# elif Input.is_action_pressed("move_right"):
		# 	target_animation = "turn_right"
	else:
		target_animation = "player_idle"

	# print_debug(anim_playback.get_travel_path())

	if anim_playback.get_current_node() != target_animation:
		anim_playback.travel(target_animation)
