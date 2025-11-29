extends Control

func _on_play_offline_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.game_controller.change_3d_scene("res://Scenes/Levels/TestLevels/City2/City2.tscn")
	Global.game_controller.change_gui_scene("res://Singleton/IngameMenu/IngameMenu.tscn")
