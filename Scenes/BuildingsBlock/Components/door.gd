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
			rotation_degrees.y = 0
			door_state = DOOR_STATE_TYPE.CLOSE
		DOOR_STATE_TYPE.CLOSE:
			rotation_degrees.y = 90
			door_state = DOOR_STATE_TYPE.OPEN


func _on_state_changed() -> void:
	if decor_state == DECOR_STATE_TYPE.BROKEN_DOWN:
		set_collision_layer_value(1, false)
		sleeping = false
		freeze = false
