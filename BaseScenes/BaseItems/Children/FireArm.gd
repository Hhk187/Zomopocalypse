extends BaseItem
class_name FireArm



var fire_cooldown := Time.get_ticks_msec()
func fire():
	var sfx := AudioStreamPlayer3D.new()
	sfx.stream = item_data.sfx_fire
	
	sfx.pitch_scale = randf_range(0.8, 2)
	add_child(sfx)
	sfx.play()
	
	fire_cooldown = Time.get_ticks_msec()

	# Free the audio player via a thread when it finishes
	sfx.finished.connect(func():
		var thread := Thread.new()
		thread.start(Callable(self, "_thread_free_node").bind(sfx))
		thread.wait_to_finish()
	)


var right_hand_target_offset: Marker3D 
	
var right_hand_offset_og_trans: Transform3D

func update(entity : BaseEntity):



	if (Input.is_action_pressed("play_fire") and Time.get_ticks_msec() - fire_cooldown > item_data.fire_rate):
		entity.test_use_weapon()
		fire()
	
