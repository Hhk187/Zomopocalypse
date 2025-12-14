extends Node
class_name InventoryData

const DEFAULT_WIDTH := 8
const DEFAULT_HEIGHT := 5


signal move_to(from_index: InventoryContainerData, to_index: InventoryContainerData)
signal add(item: BaseItem)
signal remove(index: InventoryContainerData) 
# Subject to change
signal use(index: InventoryContainerData)
signal equipe(index: InventoryContainerData)



	
var grid: Array[Array]
var items_data: Dictionary[ItemDataRes, Vector2i]
		



func _ready() -> void:
	_populate_data()
	# move_to.connect(_on_move_to)
	add.connect(_on_add)


func _populate_data():
	if grid.is_empty(): 
		for i in range(DEFAULT_HEIGHT):
			var row: Array = []
			row.resize(DEFAULT_WIDTH)
			row.fill(null)
			grid.append(row)
	

func _on_add(item: BaseItem):
	var item_data : ItemDataRes = item.item_data.duplicate(true)
	item.queue_free()
	items_data[item_data] = Vector2i.ZERO
	



func get_item_form_coord(coord : Vector2i) -> ItemDataRes:
	if grid[coord.x][coord.y] == null: return null




func get_coord_from_item(item : ItemDataRes) -> Array[Vector2i]: # -> [position, (width, height)]
	if not items_data.has(item): return []
	
	var coord: Vector2i = items_data[item]
	return [coord, Vector2i(item.tiles_width, item.tiles_height)]

# func _on_move_to(from_index: int, to_index: int):
# 	var first = data[from_index]
# 	var second = data[to_index]
	
# 	data[to_index] = first
# 	data[from_index] = second
	
	
	# for container in data:
	# 	if not container.item_data: 
	# 		container.item_data = item.item_data.duplicate(true)
	# 		container.icon = await TextureExtractor.get_texture(item)
	# 		item.queue_free()
	# 		break
	# 		return OK
			
	# return FAILED
