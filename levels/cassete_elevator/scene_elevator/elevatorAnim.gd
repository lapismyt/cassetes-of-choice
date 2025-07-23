extends AnimationPlayer


func _ready():
	if 1:
		play("animation_open")

		play("animation_close", -1, -1, true)
		print_debug("elevator animation played")
