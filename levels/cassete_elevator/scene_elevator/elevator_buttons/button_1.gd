extends ElevatorButtonInteractable


func elevator_button_interaction() -> void:
    if not check_transition():
        print("Elevator in transition")
        return

    var elevator_scene: Node = find_parent("ElevatorScene")
    if elevator_scene == null:
        print("Elevator scene not found")
        return

    var void_station: PackedScene = preload(
        "res://levels/cassete_elevator/mirror_station/mirror_station.tscn"
    )

    if elevator_scene.current_station == void_station:
        print("Mirror station already selected")
        return

    SignalBus.change_elevator_station_sig.emit(void_station)
