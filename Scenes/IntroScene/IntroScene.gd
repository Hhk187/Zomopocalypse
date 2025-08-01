extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("OpenUp")


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		animation_player.speed_scale = 5
