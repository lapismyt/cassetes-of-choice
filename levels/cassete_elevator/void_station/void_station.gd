extends Node3D

var height_limit: float = -4.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DataStoreGlobal.player == null:
		push_error("Player not found")


func _physics_process(delta: float) -> void:
	if DataStoreGlobal.player.transform.origin.y < height_limit:
		print_debug("Player is below height limit")
		var game_manager: Node = get_tree().root.find_child("GameManager", false, false)
		if game_manager == null:
			push_error("Game manager not found")
		game_manager.enable_dummy_stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
