extends WorldDecor


enum DOOR_STATE_TYPE {
	OPEN,
	CLOSE
}

var door_state : DOOR_STATE_TYPE = DOOR_STATE_TYPE.CLOSE


func _on_interact():
	if not is_operational(): return
	match door_state:
		DOOR_STATE_TYPE.OPEN:
			rotation_degrees.y = 90
			door_state = DOOR_STATE_TYPE.CLOSE
			_play_sound(load("res://Assets/SFX/WorldDecor/Openning/Open.wav"))
		DOOR_STATE_TYPE.CLOSE:
			rotation_degrees.y = 0
			door_state = DOOR_STATE_TYPE.OPEN
			_play_sound(load("res://Assets/SFX/WorldDecor/Openning/Open.wav"))


func _on_state_changed() -> void:
	if decor_state == DECOR_STATE_TYPE.BROKEN_DOWN:
		_play_sound(load("res://Assets/SFX/WorldDecor/Break/Break.wav"))
		set_collision_layer_value(1, false)
		sleeping = false
		freeze = false
