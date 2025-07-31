extends PlayerBaseState





func physics_process(delta):
	just_fall(delta)
	
	if entity.is_on_floor():
		change_state("walking")
	
	movements(delta)
	interaction()

	
