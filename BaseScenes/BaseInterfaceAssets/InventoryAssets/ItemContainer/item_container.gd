extends PanelContainer







func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print(name + "pressing")
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			print(name + "relEased")
