extends Marker3D
class_name RightHand

@onready var offset: Marker3D = $"../SubViewportContainerPOV/SubViewport/CameraPOV/RightHandPOV/Offset"
@onready var combat_ray: RayCast3D = $"../CombatRay"
@onready var animation_player: AnimationPlayer = $"../SubViewportContainerPOV/SubViewport/CameraPOV/RightHandPOV/AnimationPlayer"

func _on_child_entered_tree(node: BaseItem) -> void:
	var model = node.find_child("Model").duplicate() as Node3D
	offset.add_child(model)
	var meshs = model.find_children("*", "MeshInstance3D", true, false) as Array[MeshInstance3D]
	for mesh in meshs:
		mesh.call_deferred("set_layer_mask_value", 2, false)
		mesh.call_deferred("set_layer_mask_value", 3, true)
	owner.equiped_weapon = node
	animation_player.play("pullup_weapon")
	



func _on_child_exiting_tree(node: Node) -> void:
	node.equiped_pos = get_parent().global_position
	node.basis_z = get_parent().global_basis.z
	offset.get_child(3).queue_free()
	animation_player.play("pullup_fists")
