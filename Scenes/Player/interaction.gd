extends Area3D
class_name InteractionArea

@onready var hand_attach_bone: Marker3D = $"../Model/BaseCharacter/Armature/Skeleton3D/HandAttachBone/Offset"


func pick_up_item():
	var items : Array[BaseItem]
	for item in get_overlapping_bodies():
		if item.is_in_group("item"):
			items.append(item)
	
	if items:
		items[0].equipe(hand_attach_bone)

func drop_item():
	if hand_attach_bone.get_children():
		hand_attach_bone.get_children()[0].un_equipe()


func interact():
	var interactibles : Array[WorldDecor]
	for interactible in get_overlapping_bodies():
		if interactible.is_in_group("interact"):
			interactibles.append(interactible)
	if interactibles:
		interactibles[0].emit_signal("interact")
