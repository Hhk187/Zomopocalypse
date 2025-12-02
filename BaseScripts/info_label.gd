@tool
extends Label3D
class_name InfoLabel

@export var y_pos: float = 1.0
@export var target: Node3D
@export var use_world_up: bool = true

func _ready():
	if target == null:
		target = get_parent()
	# Do not inherit parent's transform (rotation/scale)
	top_level = true
	# Keep facing camera (optional)
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_update_pos()

func _process(_delta):
	_update_pos()

func _update_pos():
	if target:
		var up_dir := Vector3.UP if use_world_up else target.global_basis.y
		global_position = target.global_transform.origin + up_dir * y_pos
