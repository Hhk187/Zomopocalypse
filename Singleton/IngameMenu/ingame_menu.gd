extends CanvasLayer
class_name InGameMenu

@onready var center_container: CenterContainer = $CenterContainer
@onready var fps_label: Label = $FPSLabel

func _physics_process(_delta: float) -> void:
	fps_label.text = "FPS : %s" % Engine.get_frames_per_second()


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
			center_container.visible = !center_container.visible
			mouse_mode = center_container.visible
		if event.is_action_pressed("debug_mouse_toggle"):
			mouse_mode = !mouse_mode

func _on_toggle_fullscreen_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_windowed_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_fullscreen_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_quit_pressed() -> void:
	get_tree().quit()
