extends Control


var mouse_mode : bool = false:
	set(value):
		mouse_mode = value
		PlayerBaseState.can_look_around = !value
		if mouse_mode:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			visible = !visible
			mouse_mode = visible
		if event.is_action_pressed("debug_mouse_toggle"):
			mouse_mode = !mouse_mode

func _on_toggle_fullscreen_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_windowed_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
