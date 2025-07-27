extends AnimationPlayer


func _ready():
	# if 1:
	# 	play("animation_open")

	# 	play("animation_close", -1, -1, true)
	# 	print_debug("elevator animation played")
	close_doors()

	SignalBus.elevator_open_doors.connect(open_doors)
	SignalBus.elevator_close_doors.connect(close_doors)
	SignalBus.elevator_transition_started.connect(close_doors)
	SignalBus.elevator_transition_completed.connect(open_doors)


func open_doors() -> void:
	# print_debug("elevator open played")
	if not DataStoreElevator.elevator_open:
		play("animation_close", -1, -1, true)
		DataStoreElevator.elevator_open = true


func close_doors() -> void:
	# print_debug("elevator close played")
	if DataStoreElevator.elevator_open:
		play("animation_close")
		DataStoreElevator.elevator_open = false
