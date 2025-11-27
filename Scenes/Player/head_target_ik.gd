@tool
extends Marker3D
class_name HeadTargetIK

const LOOKING_DICT = {
	"u":{
		"pos" : Vector3(0.0, 1.624, 0.134),
		"rot" : Vector3(-90, 180, 0)
		},
	"f":{
		"pos" : Vector3(0.0, 1.6, -0.017),
		"rot" : Vector3(0, 180, 0)
		},
	"d":{
		"pos" : Vector3(0.0, 1.513, -0.228),
		"rot" : Vector3(90, 180, 0)
		},
}

@export_enum("u", "f", "d") var looking : String = "f"
	#set(value):
		#looking = value
		#position = LOOKING_DICT[value].pos
		#rotation = LOOKING_DICT[value].rot * (PI/180)

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

func _physics_process(delta: float) -> void:
	_update_look_from_slider()
