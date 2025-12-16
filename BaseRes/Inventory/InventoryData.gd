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
var items_data: Dictionary[InventoryContainerData, Vector2i]



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
	var inventory_container_data = InventoryContainerData.new() 
	inventory_container_data.item_data = item_data
	inventory_container_data.icon = await TextureExtractor.get_texture(item)
	
	items_data[inventory_container_data] = Vector2i.ZERO # TODO: should get next available
	var coord = _get_coords_from_inventory_container_data(inventory_container_data)
	_set_coord_grid(coord, inventory_container_data)

	for h in range(1, item_data.tiles_height):
		grid[h][coord.y] = '|'

	for h in item_data.tiles_height:
		for w in range(1, item_data.tiles_width):
			grid[h][w] = '-'

func _on_move():
	pass


func _get_coords_from_inventory_container_data(data : InventoryContainerData) -> Vector2i:
	return items_data[data]

func _set_coord_grid(coord : Vector2i, data : Variant):
		grid[coord.x][coord.y] = data

# func get_item_from_coord(coord : Vector2i) -> ItemDataRes:
# 	return grid[coord.x][coord.y]


# func get_coord_from_item(item : ItemDataRes) -> Array[Vector2i]: # -> [position, (width, height)]
# 	if not items_data.has(item): return []
	
# 	var coord: Vector2i = items_data[item]
# 	return [coord, Vector2i(item.tiles_width, item.tiles_height)]


func get_size() -> Vector2i:
	return Vector2i(grid[0].size(), grid.size())
