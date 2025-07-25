extends AnimationPlayer

#@onready var anim_tree = $AnimationTree
#@onready var state_machine = anim_tree["parameters/playback"]


func _process(_delta: float) -> void:
	var is_walking = Input.is_action_pressed("move_forward")

	if is_walking:
		play("player_walk")
	else:
		play("player_idle")
