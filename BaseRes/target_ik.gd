@tool
extends Marker3D
class_name TargetIK
## TODO: make it so it has mutiple states for different equipment (like aiming down sights, holding a rifle, holding a pistol, holding a melee weapon, etc)
## TargetIK is a Marker3D node used for inverse kinematics targeting in 3D space.
## It allows setting predefined positions and rotations for looking directions (up, forward, down)
## and provides a slider to interpolate between these directions.

## Dictionary holding predefined positions and rotations for looking directions
@export var LOOKING_DICT = {
	"u":{
		"pos" : Vector3.ZERO,
		"rot" : Vector3.ZERO
		},
	"f":{
		"pos" : Vector3.ZERO,
		"rot" : Vector3.ZERO
		},
	"d":{
		"pos" : Vector3.ZERO,
		"rot" : Vector3.ZERO
		},
}

@export var save_up_pos : bool:
	set(value):
		if value:
			save_up_pos = false
			LOOKING_DICT["u"].pos = position
			LOOKING_DICT["u"].rot = rotation * (180/PI)
			set_owner(owner)
@export var save_forward_pos : bool:
	set(value):
		if value:
			save_forward_pos = false
			LOOKING_DICT["f"].pos = position
			LOOKING_DICT["f"].rot = rotation * (180/PI)
			set_owner(owner)
@export var save_down_pos : bool:
	set(value):
		if value:
			save_down_pos = false
			LOOKING_DICT["d"].pos = position
			LOOKING_DICT["d"].rot = rotation * (180/PI)
			set_owner(owner)


@export_range(-10.0, 10.0, 0.1) var look_slider : float = 0:
	set(value):
		look_slider = value
		_update_look_from_slider()

var target_pos : Vector3
var target_rot : Vector3


func _update_look_from_slider() -> void:
	# Normalize slider value from [-10, 10] to [0, 1] range
	var normalized = (look_slider + 10.0) / 20.0
	
	if normalized <= 0.5:
		# Interpolate between "u" (up) and "f" (forward)
		var t = normalized * 2.0  # Map [0, 0.5] to [0, 1]
		target_pos = lerp(LOOKING_DICT["u"].pos, LOOKING_DICT["f"].pos, t)
		target_rot = lerp(LOOKING_DICT["u"].rot, LOOKING_DICT["f"].rot, t)
	else:
		# Interpolate between "f" (forward) and "d" (down)
		var t = (normalized - 0.5) * 2.0  # Map [0.5, 1] to [0, 1]
		target_pos = lerp(LOOKING_DICT["f"].pos, LOOKING_DICT["d"].pos, t)
		target_rot = lerp(LOOKING_DICT["f"].rot, LOOKING_DICT["d"].rot, t)

	position = target_pos
	rotation = target_rot * (PI/180)
