extends Node
class_name InventoryData

const DEFAULT_SIZE := 20

signal move_to(from_index: InventoryContainerData, to_index: InventoryContainerData)
signal add(item: BaseItem)
signal remove(index: InventoryContainerData) 
# Subject to change
signal use(index: InventoryContainerData)
signal equipe(index: InventoryContainerData)


## STATS
var size: int:
	set(value):
		size = value
		# Creates InventoryContainerData if there is none
		if data.is_empty(): 
			for i in range(size):
				data.append(InventoryContainerData.new())
		# Update the siza correclty if it ever got changed
		elif data.size() != size:
			var correction = size - data.size()
			if correction > 0:
				data.append(InventoryContainerData.new())
			else:
				data.pop_back()

@export var data : Array[InventoryContainerData]

func _ready() -> void:
	size = DEFAULT_SIZE
	move_to.connect(_on_move_to)
	add.connect(_on_add)

func _on_move_to(from_index: int, to_index: int):
	var first = data[from_index]
	var second = data[to_index]
	
	data[to_index] = first
	data[from_index] = second

func _on_add(item: BaseItem):
	for container in data:
		if not container.item_data: 
			container.item_data = item.item_data.duplicate(true)
			container.icon = await TextureExtractor.get_texture(item)
			item.queue_free()
			break
			return OK
			
	return FAILED
