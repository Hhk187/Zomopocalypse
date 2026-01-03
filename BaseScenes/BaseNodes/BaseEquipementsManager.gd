extends Node
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

# TODO: these needs clothing models
@export var head: Node3D
@export var upper_body: Node3D
@export var lower_body: Node3D
@export var hands: Node3D
@export var foot: Node3D

var right_hand_weapon_equiped: BaseItem
var left_hand_weapon_equiped: BaseItem  

@onready var inventory_data: InventoryData = $"../InventoryData"


func _ready() -> void:
	if not inventory_data: 
		push_error("ERROR : BaseEquipementsManager DID NOT FIND THE OWNER'S InventoryData NODE")
		return
	
	inventory_data.update_equipement.connect(_on_equipement_updated)


func _on_equipement_updated():
    


	if not back1.get_child_count() and inventory_data.weapon1.base_item:
		inventory_data.weapon1.base_item.equipe(back1)
	elif back1.get_child_count() and not inventory_data.weapon1.base_item:
		back1.get_child(0).un_equipe()
