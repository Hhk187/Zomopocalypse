extends Node3D
class_name BaseEquipementsManager

## This manages what items is equiped by th player/entity [br]
## It spawns/de-spawns the item from the entity's hand [br]
## Owner has to be [BaseEntity] [br]
## Has to have [BoneAttachment3D] as children with a [Marker3D] as child [br]
signal weapon_equiped_finished
signal weapon_equiping

enum SLOT {
	FIRST,
	SECOND,
	THIRD,
	NONE
}
var slot_equiped: SLOT = SLOT.NONE
var equiping: bool = false

var cooldown: Timer = Timer.new()

@export var right_hand: Node3D
@export var left_hand: Node3D

@export var back1: Node3D
@export var back2: Node3D
@export var back3: Node3D

# Idk about these slots, they need special checks to work correctly
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
	weapon_equiped_finished.connect(_on_weapon_equiped_finished)
	weapon_equiping.connect(_on_weapon_equiping)
	
	_populate()
	if not inventory_data: 
		push_error("ERROR : BaseEquipementsManager DID NOT FIND THE OWNER'S InventoryData NODE")
		return
	inventory_data.update_equipement.connect(_on_equipement_updated)



	# if not animation_tree:
	# 	push_error("ERROR : BaseEquipementsManager DID NOT FIND THE OWNER'S AnimationTree NODE")
	# 	return
	
func _populate():
	add_child(cooldown)
	back_array.append(back1) #
	back_array.append(back2) # This fixes the fact that variables are getting forgot when assigning directly
	back_array.append(back3) #
	for back in back_array:
		back.set_meta("has_item", false)


	up_leg_array.append(right_up_leg)
	up_leg_array.append(left_up_leg)


func _on_equipement_updated():
	for index in inventory_data.weapon_containers.size():
		var weapon_container := inventory_data.weapon_containers[index]
		var back_marker := back_array[index]
		
		if not back_marker.get_child_count() and weapon_container.base_item:
			weapon_container.base_item.equipe(back_marker)
			back_marker.set_meta("has_item", true)
			
		elif (back_marker.get_child_count() and not weapon_container.base_item) or index == slot_equiped:
			await un_equip_weapon(index) # un-equip specific weapon if it's in hand
			back_marker.get_child(0).un_equip()
			back_marker.set_meta("has_item", false)





var left_hand_blend = 0.0
func equipe_weapon(slot : SLOT) -> void:

	var back := back_array[slot]

	if not back.get_meta("has_item"): return
	if slot_equiped != SLOT.NONE or equiping or right_hand_weapon_equiped: return

	weapon_equiping.emit()

	animation_tree.reach_back_weapon()
	
	await get_tree().create_timer(0.4).timeout

	right_hand_weapon_equiped = back.get_child(0)
	back.remove_child(right_hand_weapon_equiped)
	right_hand.add_child(right_hand_weapon_equiped)
	
	var tween := create_tween()
	tween.tween_property(self, "left_hand_blend", 1.0, 0.4)
	tween.play()

	

	await get_tree().create_timer(0.4).timeout
	
	animation_tree.left_hand_ik.target_node = right_hand_weapon_equiped.get_child(-1).get_path()
	animation_tree.right_hand_ik.active = true
	animation_tree.left_hand_ik.active = true

	slot_equiped = slot

	weapon_equiped_finished.emit()

## un-equip the specified weapon if it's in hand [br]
func un_equip_weapon(slot : SLOT):
	

	if slot_equiped != slot: return 

	weapon_equiping.emit()
	var back = back_array[slot]

	animation_tree.reach_back_weapon()
	var tween := create_tween()
	tween.tween_property(self, "left_hand_blend", 0.0, 0.4)
	tween.play()
	
	animation_tree.right_hand_ik.active = false
	animation_tree.left_hand_ik.active = false
	
	
	cooldown.start(0.4)
	await cooldown.timeout
	
	
	right_hand.remove_child(right_hand_weapon_equiped)
	back.add_child(right_hand_weapon_equiped)
	back.get_child(0)._toggle(true)
	
	slot_equiped = SLOT.NONE
	right_hand_weapon_equiped = null


	weapon_equiped_finished.emit()


func free_hands():
	if slot_equiped == SLOT.NONE or equiping or not right_hand_weapon_equiped: return

	weapon_equiping.emit()
	var back = back_array[slot_equiped]

	animation_tree.reach_back_weapon()
	var tween := create_tween()
	tween.tween_property(self, "left_hand_blend", 0.0, 0.4)
	tween.play()
	
	animation_tree.right_hand_ik.active = false
	animation_tree.left_hand_ik.active = false
	
	cooldown.start(0.4)
	await cooldown.timeout
	
	
	right_hand.remove_child(right_hand_weapon_equiped)
	back.add_child(right_hand_weapon_equiped)
	back.get_child(0)._toggle(true)
	

	slot_equiped = SLOT.NONE
	right_hand_weapon_equiped = null

	weapon_equiped_finished.emit()

### Singals #############################
func _on_weapon_equiped_finished():
	equiping = false

func _on_weapon_equiping():
	equiping = true
#########################################


func _physics_process(delta: float) -> void:
	for index in back_array.size():
		if Input.is_action_just_pressed("play_weapon_%s" % (index + 1)):
			equipe_weapon(index)
	
	if Input.is_action_just_pressed("play_hands_free"):
		free_hands()


	animation_tree.equip_weapon_two_handed(left_hand_blend)
