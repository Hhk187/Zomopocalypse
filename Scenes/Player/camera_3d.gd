extends Camera3D
class_name CameraPlayer

static var camera_sway : Vector3

func _physics_process(delta: float) -> void:
	rotation.z += camera_sway.x
	rotation.z = clampf(rotation.z, -0.2, 0.2)
	rotation.z = lerp(rotation.z, 0.0, 0.3)
	camera_sway = camera_sway.lerp(Vector3.ZERO, delta*5)
	

static func sway3D(sway_amount : Vector3):
	camera_sway -= sway_amount
