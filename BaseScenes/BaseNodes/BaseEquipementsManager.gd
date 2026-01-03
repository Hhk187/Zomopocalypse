extends Node3D
class_name BaseEquipementsManager

## This manages what items is equiped by th player/entity [br]
## It spawns/de-spawns the item from the entity's hand [br]
## Owner has to be [BaseEntity] [br]
## Has to have [BoneAttachment3D] as children with a [Marker3D] as child [br]


@export var right_hand: Node3D
@export var left_hand: Node3D

@export var back1: Node3D
@export var back2: Node3D
@export var back3: Node3D
@export var right_up_leg: Node3D
@export var left_up_leg: Node3D

var back_array: Array[Node3D]
var up_leg_array: Array[Node3D]


# TODO: these needs clothing models
@export var head: Node3D
@export var upper_body: Node3D
@export var lower_body: Node3D
@export var hands: Node3D
@export var foot: Node3D

var right_hand_weapon_equiped: BaseItem
var left_hand_weapon_equiped: BaseItem  

@onready var inventory_data: InventoryData = $"../InventoryData"
@onready var animation_tree: EntityAnimationTree = $"../AnimationTree"

func _ready() -> void:
	_populate()
	if not inventory_data: 
		push_error("ERROR : BaseEquipementsManager DID NOT FIND THE OWNER'S InventoryData NODE")
		return
	inventory_data.update_equipement.connect(_on_equipement_updated)

	# if not animation_tree:
	# 	push_error("ERROR : BaseEquipementsManager DID NOT FIND THE OWNER'S AnimationTree NODE")
	# 	return
	

## This fixes the fact that variables are getting forgot when assigning directly
func _populate():
	back_array.append(back1)
	back_array.append(back2)
	back_array.append(back3)

	up_leg_array.append(right_up_leg)
	up_leg_array.append(left_up_leg)


func _on_equipement_updated():
	for index in inventory_data.weapon_containers.size():
		var weapon_container := inventory_data.weapon_containers[index]
		var back_marker := back_array[index]
		
		if not back_marker.get_child_count() and weapon_container.base_item:
			weapon_container.base_item.equipe(back_marker)
			back_marker.set_meta("has_item", true)
			
		elif back_marker.get_child_count() and not weapon_container.base_item:
			back_marker.get_child(0).un_equipe()
			back_marker.set_meta("has_item", false)

var blend_value = 0.0
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("play_weapon_1"):
		if not back1.get_meta("has_item"): return
		if not right_hand_weapon_equiped:

			animation_tree.reach_back_weapon()
			
			await get_tree().create_timer(0.8).timeout

			right_hand_weapon_equiped = back1.get_child(0)
			back1.remove_child(right_hand_weapon_equiped)
			right_hand.add_child(right_hand_weapon_equiped)
			
			var tween := create_tween()
			tween.tween_property(self, "blend_value", 1.0, 1)
			tween.play()

			

			await get_tree().create_timer(0.8).timeout
			
			animation_tree.left_hand_ik.target_node = right_hand_weapon_equiped.get_child(-1).get_path()
			animation_tree.right_hand_ik.active = true
			animation_tree.left_hand_ik.active = true
			
		else :
			
			
			animation_tree.reach_back_weapon()
			var tween := create_tween()
			tween.tween_property(self, "blend_value", 0.0, 1)
			tween.play()
			
			animation_tree.right_hand_ik.active = false
			animation_tree.left_hand_ik.active = false
			
			await get_tree().create_timer(0.8).timeout
			
			
			right_hand.remove_child(right_hand_weapon_equiped)
			back1.add_child(right_hand_weapon_equiped)
			back1.get_child(0)._toggle(true)
			
			right_hand_weapon_equiped = null

		
	animation_tree.equip_weapon_two_handed(blend_value)

	
