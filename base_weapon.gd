extends RigidBody3D
class_name BaseItem

@export var item_data : ItemDataRes

@onready var model: Node3D = $Model
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var parent : Node
var equiped_pos : Vector3
var basis_z : Vector3

func _ready() -> void:
	parent = get_parent() as Node

func un_equipe():
	get_parent().remove_child(self)
	if parent:
		parent.add_child(self)
	toggle(false)

func equipe():
	get_parent().remove_child(self)
	toggle(true)


func toggle(value : bool):
	var meshs = model.find_children("*", "MeshInstance3D") as Array[MeshInstance3D]
	for mesh in meshs:
		mesh.set_layer_mask_value(1, !value)
		mesh.set_layer_mask_value(2, value)
	freeze = value
	sleeping = value
	collision_shape_3d.disabled = value
	if value:
		rotation = basis_z
		position = Vector3.ZERO
	else:
		global_position = equiped_pos
		linear_velocity -= basis_z * 5
		top_level = !value
