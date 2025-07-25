extends ElevatorButtonInteractable


func elevator_button_interaction() -> void:
	if not check_transition():
		return
	SignalBus.change_elevator_station_sig.emit(
		preload("res://levels/cassete_elevator/void_station/void_station.tscn")
	)
