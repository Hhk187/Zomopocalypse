extends Node
class_name BaseEquipementsManager

## This manages what items is equiped by th player/entity [br]
## It spawns/de-spawns the item from the entity's hand

signal equip
signal un_equip





@export var right_hand: Node3D
@export var left_hand: Node3D

@export var back1: Node3D
@export var back2: Node3D
@export var hip1: Node3D
@export var hip2: Node3D

# TODO: these needs clothing models
@export var head: Node3D
@export var upper_body: Node3D
@export var lower_body: Node3D
@export var hands: Node3D
@export var foot: Node3D











