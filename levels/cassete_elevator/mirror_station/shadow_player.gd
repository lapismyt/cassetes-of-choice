extends CharacterBody3D

@onready var mirror_station = get_parent()


func _physics_process(delta: float) -> void:
	if DataStoreGlobal.player == null:
		return

	var player_pos = DataStoreGlobal.player.position

	var reflected_pos = Vector3(player_pos.x, player_pos.y, -player_pos.z)

	var mirror_pos = Vector3(0, 0, -3.1)

	rotation.y = -DataStoreGlobal.player.rotation.y

	velocity = (reflected_pos + mirror_pos - position) / delta
	move_and_slide()
