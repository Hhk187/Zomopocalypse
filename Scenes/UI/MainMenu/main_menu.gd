extends Control

func _on_play_offline_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.game_controller.change_scene(GameController.SCENES["3d"]["city"], "3d", GameController.COMMANDS.REMOVE)
	Global.game_controller.change_scene(GameController.SCENES["gui"]["ingame_menu"], "gui", GameController.COMMANDS.REMOVE)


func _on_quit_pressed() -> void:
	get_tree().quit()
