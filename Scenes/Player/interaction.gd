extends Area3D
class_name InteractionArea

@onready var hand_attach_bone: Marker3D = $"../Model/BaseCharacter/rig/Skeleton3D/HandAttachBone/Offset"


func pick_up_item():
	var items : Array[BaseItem]
	for item in get_overlapping_bodies():
		if item.is_in_group("item"):
			items.append(item)
	
	items[0].equipe()
	hand_attach_bone.add_child(items[0])
	
