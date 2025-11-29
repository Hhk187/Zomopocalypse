extends RigidBody3D
class_name BaseItem

@export var item_data : ItemDataRes

@onready var model: Node3D = $Model
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var items_parent : Node
var equiped_pos : Vector3
var basis_z : Vector3

func _ready() -> void:
	items_parent = get_parent() as Node

func un_equipe():
	get_parent().remove_child(self)
	if items_parent:
		items_parent.add_child(self)
	_toggle(false)

func equipe(new_parent : Node):
	get_parent().remove_child(self)
	new_parent.add_child(self)
	_toggle(true)


## Prepare item to be equiped/unequiped
func _toggle(value : bool):
	freeze = value
	sleeping = value
	collision_shape_3d.disabled = value
	if value:
		linear_velocity = Vector3.ZERO
		position = Vector3.ZERO
		rotation = Vector3.ZERO
	else:
		rotation = Vector3(
			randf() * PI,
			randf() * PI,
			randf() * PI
		)
		angular_velocity = Vector3(
			randf() * PI,
			randf() * PI,
			randf() * PI
		)
		global_position = equiped_pos
		linear_velocity -= basis_z * 5
		top_level = !value

func _physics_process(delta: float) -> void:
	Global.debug_manager.update_debug_info(name, global_position)
