extends CharacterBody3D

@onready var mirror_station = get_parent()
@onready var animation_player: AnimationPlayer = $blockbench_export/AnimationPlayer


func _physics_process(delta: float) -> void:
	if DataStoreGlobal.player == null:
		return

	var player_pos = DataStoreGlobal.player.position

	var reflected_pos = Vector3(player_pos.x, player_pos.y, -player_pos.z)

	var mirror_pos = Vector3(0, 0, -3.1)

	rotation.y = -DataStoreGlobal.player.rotation.y

	velocity = (reflected_pos + mirror_pos - position) / delta
	move_and_slide()

	# Sync animations with the player
	sync_player_animations()


func sync_player_animations():
	if DataStoreGlobal.player == null:
		return

	# Get the player's animation tree and current animation
	var player_animation_tree = DataStoreGlobal.player.animation_tree
	var player_anim_playback = DataStoreGlobal.player.anim_playback

	if player_animation_tree == null or player_anim_playback == null:
		return

	# Get the current animation name
	var current_animation = player_anim_playback.get_current_node()

	# Play the same animation on the shadow player
	if current_animation != "" and animation_player.has_animation(current_animation):
		if animation_player.current_animation != current_animation:
			animation_player.play(current_animation)
