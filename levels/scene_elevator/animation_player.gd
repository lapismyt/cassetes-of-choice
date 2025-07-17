extends AnimationPlayer

@onready var anim_tree = $AnimationTree
#@onready var state_machine = anim_tree["parameters/playback"]

func _process(delta):
	var is_walking = Input.is_action_pressed("move_forward")
	
	if is_walking:
		play("player_walk")  # Плавный переход благодаря blend time
	else:
		play("player_idle")
		
