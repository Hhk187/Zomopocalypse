extends Control

func _on_play_offline_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://Scenes/Levels/TestLevels/City2/City2.tscn")
