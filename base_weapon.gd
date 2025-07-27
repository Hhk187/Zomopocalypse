extends RigidBody3D
class_name BaseWeapon

@onready var model: Node3D = $Model
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D



func un_equipe():
	toggle(false)

func equipe():
	toggle(true)


func toggle(value : bool):
	var meshs = model.find_children("*", "MeshInstance3D") as Array[MeshInstance3D]
	print(meshs)
	for mesh in meshs:
		mesh.set_layer_mask_value(1, !value)
		mesh.set_layer_mask_value(2, value)
		mesh.set_layer_mask_value(3, !value)
	freeze = value
	sleeping = value
	collision_shape_3d.disabled = value
	if value:
		rotation = Vector3.ZERO
		position = Vector3.ZERO
	else:
		linear_velocity -= transform.basis.z * 2
		top_level = !value
