extends Camera3D
class_name CameraPOV

var sway : Vector3
var camera_sway : Vector3

var player : PlayerBaseEntity

func _ready() -> void:
	player = owner as PlayerBaseEntity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	sway = sway.lerp(Vector3.ZERO, 1)
	rotation += camera_sway
	camera_sway = camera_sway.lerp(Vector3.ZERO, 1)


func sway2D(sway_amount : Vector2):
	sway.x -= sway_amount.x*0.0001
	sway.y += sway_amount.y*0.0001


func sway3D(sway_amount : Vector3):
	sway -= sway_amount
	camera_sway -= sway_amount
