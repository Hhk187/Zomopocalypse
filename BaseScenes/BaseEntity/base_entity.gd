extends CharacterBody3D
class_name BaseEntity



@export var can_move: bool = true
@export var can_look_around: bool = true



@onready var inventory_data: InventoryData = $InventoryData
