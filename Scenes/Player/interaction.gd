extends Area3D
class_name InteractionArea

@onready var hand_attach_bone: Marker3D = $"../Model/BaseCharacter/Armature/Skeleton3D/HandAttachBone/Offset"
@onready var camera_ray_cast: RayCast3D:
	get():
		if not camera_ray_cast:
			camera_ray_cast = owner.camera_ray_cast
		return camera_ray_cast

var has_pickable: BaseItem
var has_interactibles: Array[WorldDecor]


func pick_up_item():
	var items: Array[BaseItem]
	for item in get_overlapping_bodies():
		if item.is_in_group("item"):
			items.append(item)
	
	if focused_item in items:
		focused_item.equipe(hand_attach_bone)


func drop_item():
	if hand_attach_bone.get_children():
		hand_attach_bone.get_children()[0].un_equipe()


func interact():
	var interactibles: Array[WorldDecor]
	for interactible in get_overlapping_bodies():
		if interactible.is_in_group("interact"):
			interactibles.append(interactible)
		

	if focused_intercatible in interactibles:
		focused_intercatible.emit_signal("interact")

func _physics_process(_delta):
	detect_ray()

var focused_intercatible : WorldDecor 
var focused_item : BaseItem
func detect_ray():
	if not camera_ray_cast: return
	if camera_ray_cast.is_colliding():
		var col: Node3D = camera_ray_cast.get_collider()
		if col.is_in_group("interact"):
			if focused_intercatible:
				focused_intercatible.get_node("InfoLabel").hide()
			focused_intercatible = col
			focused_intercatible.get_node("InfoLabel").show()
			
		elif col.is_in_group("item"):
			if focused_item:
				focused_item.get_node("InfoLabel").hide()
			focused_item = col
			focused_item.get_node("InfoLabel").show()
			
	else:
		if focused_intercatible:
			focused_intercatible.get_node("InfoLabel").hide()
			focused_intercatible = null
		if focused_item:
			focused_item.get_node("InfoLabel").hide()
			focused_item = null
			


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
	
