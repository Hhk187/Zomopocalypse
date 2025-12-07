extends Node
class_name InventoryData

const DEFAULT_SIZE := 20

signal move_to(from_index: InventoryContainerData, to_index: InventoryContainerData)
signal remove(index: InventoryContainerData)
# Subject to change
signal use(index: InventoryContainerData)
signal equipe(index: InventoryContainerData)


## STATS
var size: int:
	set(value):
		size = value
		# Creates InventoryContainerData if there is none
		if inventory_containers.is_empty(): 
			for i in range(size):
				inventory_containers.append(InventoryContainerData.new())
		# Update the siza correclty if it ever got changed
		elif inventory_containers.size() != size:
			var correction = size - inventory_containers.size()
			if correction > 0:
				inventory_containers.append(InventoryContainerData.new())
			else:
				inventory_containers.pop_back()

@export var inventory_containers : Array[InventoryContainerData]

func _ready() -> void:
	size = DEFAULT_SIZE
	move_to.connect(_on_move_to)
	await get_tree().create_timer(10).timeout
	_on_move_to(0, 1)

func _on_move_to(from_index: int, to_index: int):
	var first = inventory_containers[from_index]
	var second = inventory_containers[to_index]
	
	inventory_containers[to_index] = first
	inventory_containers[from_index] = second
