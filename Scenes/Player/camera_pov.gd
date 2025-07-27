extends Camera3D
class_name CameraPOV

static var sway : Vector3

@onready var right_hand_pov: Marker3D = $RightHandPOV/Offset

var player : PlayerBaseEntity

func _ready() -> void:
	player = owner as PlayerBaseEntity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	right_hand_pov.position = sway
	sway = sway.lerp(Vector3.ZERO, delta*5)
	# right_hand_pov.position = right_hand_pov.position.clamp(right_hand_pov.position, Vector3(0.5,0.5,0.5))


static func sway2D(sway_amount : Vector2):
	sway.x -= sway_amount.x*0.00005
	sway.y += sway_amount.y*0.00005


static func sway3D(sway_amount : Vector3):
	sway -= sway_amount*0.0005
