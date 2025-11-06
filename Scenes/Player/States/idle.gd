extends PlayerBaseState





func physics_process(delta):
	if Input.get_vector("play_left", "play_right", "play_forward", "play_backward") != Vector2.ZERO:
		change_state("walking")
	gravity(delta)
	#interaction()
