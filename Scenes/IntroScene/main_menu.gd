extends Control

func _on_play_offline_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/TestLevels/City1/City1.tscn")
