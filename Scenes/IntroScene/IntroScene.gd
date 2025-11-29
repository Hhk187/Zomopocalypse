extends Node3D
@onready var camera_animation_player: AnimationPlayer = $AnimationPlayer
@onready var player1_animation_player: AnimationPlayer = $BaseCharacter/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_animation_player.play("OpenUp")
	player1_animation_player.play("intro_sittingOnCouch")


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		camera_animation_player.speed_scale = 5


func spawn_ui():
	Global.game_controller.change_gui_scene("res://Scenes/UI/MainMenu/MainMenu.tscn")
