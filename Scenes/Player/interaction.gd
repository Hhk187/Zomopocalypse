extends Area3D
class_name InteractionArea

@onready var hand_attach_bone: Marker3D = $"../Model/BaseCharacter/Armature/Skeleton3D/HandAttachBone/Offset"
@onready var camera_ray_cast: RayCast3D = owner.camera_ray_cast

var has_pickable: BaseItem
var has_interactibles: Array[WorldDecor]


#func pick_up_item():
	#var items: Array[BaseItem]
	#for item in get_overlapping_bodies():
		#if item.is_in_group("item"):
			#items.append(item)
	#
	#if items:
		#items[0].equipe(hand_attach_bone)

func drop_item():
	if hand_attach_bone.get_children():
		hand_attach_bone.get_children()[0].un_equipe()


func interact():
	var interactibles: Array[WorldDecor]
	for interactible in get_overlapping_bodies():
		if interactible.is_in_group("interact"):
			interactibles.append(interactible)
	if interactibles:
		interactibles[0].emit_signal("interact")

func _physics_process(_delta):
	if camera_ray_cast.is_colliding():
		var col : Node3D = camera_ray_cast.get_collider()
		if col.is_in_group("item"):
			col.get_node("InfoLabel").show()



#func _on_body_entered(body: Node3D):
	#match body.get_groups()[0]:
		#"interact":
			#has_interactibles.append(body)
			#has_interactibles[0].get_node("InfoLabel").show()
		#"item":
			#has_pickables.append(body)
			#has_pickables[0].get_node("InfoLabel").show()
#
#
#func _on_body_exited(body):
	#match body.get_groups()[0]:
		#"interact":
			#has_interactibles[0].get_node("InfoLabel").hide()
			#has_interactibles.erase(body)
		#"item":
			#has_pickables[0].get_node("InfoLabel").hide()
			#has_pickables.erase(body)
	
