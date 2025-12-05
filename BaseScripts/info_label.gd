@tool
extends Label3D
class_name InfoLabel

@export var top_lvl: bool = true
@export var y_pos: float = 1.0
@export var target: Node3D
@export var use_world_up: bool = true
@export var offset_pos: Vector3

func _ready():
	if target == null:
		target = get_parent()
	# Do not inherit parent's transform (rotation/scale)
	top_level = top_lvl
	# Keep facing camera (optional)
	billboard = BaseMaterial3D.BILLBOARD_ENABLED


func _process(_delta):
	if top_lvl:
		_update_pos()

func _update_pos():
	if target:
		var up_dir := Vector3.UP if use_world_up else target.global_basis.y
		global_position = target.global_transform.origin + up_dir * y_pos + offset_pos
