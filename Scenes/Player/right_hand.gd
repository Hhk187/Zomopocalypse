extends Marker3D
class_name RightHand

@onready var offset: Marker3D = $"../SubViewportContainerPOV/SubViewport/CameraPOV/RightHandPOV/Offset"

func _on_child_entered_tree(node: Node) -> void:
	if offset:
		offset.add_child(node.find_child("Model").duplicate())


func _on_child_exiting_tree(node: Node) -> void:
	offset.get_child(0).queue_free()
