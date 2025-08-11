class_name ElevatorSceneManager
extends Node3D

var current_station: PackedScene
var current_station_instance: Node3D
var transition_start_time: int
var closing_doors: bool = false
@export var door_animator: ElevatorAnim
@export var transition_duration: int = 5000
@export var transition_sound: AudioStream


func _ready() -> void:
	if door_animator == null:
		door_animator = get_node("elevator_model/ElevatorDoorAnimator")

	print_debug("door animator is " + str(door_animator))

	SignalBus.change_elevator_station_sig.connect(change_station)
	SignalBus.doors_closed.connect(doors_closed)
	SignalBus.add_debug_label.emit("Elevator Station: ???", "elevator_station")

	DataStoreGlobal.player = find_child("Player")
	print_debug("stored player")


func _exit_tree() -> void:
	# print_debug(SignalBus.remove_debug_label)
	SignalBus.remove_debug_label.emit("elevator_station")


func open_doors() -> void:
	if door_animator:
		SignalBus.elevator_open_doors.emit()


func close_doors() -> void:
	if door_animator:
		SignalBus.elevator_close_doors.emit()


func doors_closed() -> void:
	print_debug("doors closed")

	if closing_doors:
		finalize_station_changing()


func finalize_station_changing() -> void:
	print_debug("finalize_station_changing called")

	if current_station_instance:
		current_station_instance.queue_free()

	current_station_instance = current_station.instantiate()
	SignalBus.elevator_transition_started.emit()
	add_child(current_station_instance)

	SignalBus.update_debug_label.emit(
		"Elevator Station: " + current_station_instance.name, "elevator_station"
	)

	closing_doors = false


func change_station(station: PackedScene) -> void:
	current_station = station
	DataStoreElevator.elevator_in_transition = true
	transition_start_time = Time.get_ticks_msec()

	if not door_animator.doors_opened:
		finalize_station_changing()
		return

	print_debug("closing doors")
	close_doors()
	closing_doors = true


func _process(_delta: float) -> void:
	if DataStoreElevator.elevator_in_transition:
		if (
			(Time.get_ticks_msec() - transition_start_time) >= transition_duration
			and not closing_doors
		):
			DataStoreElevator.elevator_in_transition = false
			open_doors()
			SignalBus.elevator_transition_completed.emit()
