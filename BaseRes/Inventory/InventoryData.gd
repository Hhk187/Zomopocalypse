extends Node
class_name InventoryData

const DEFAULT_WIDTH := 8
const DEFAULT_HEIGHT := 5


signal move_to(
	inventory_container_data: InventoryContainerData,
	from_index: Vector2i,
	to_index: Vector2i)

signal add(item: BaseItem)
signal remove(index: InventoryContainerData) 
# Subject to change
signal use(index: InventoryContainerData)
signal equipe(index: InventoryContainerData)




var grid: Array[Array]
var items_data: Dictionary[InventoryContainerData, Vector2i]

var backpack : Dictionary[InventoryContainerData, Vector2i]

var weapon1 : InventoryContainerData
var weapon2 : InventoryContainerData
var pocket1 : InventoryContainerData
var pocket2 : InventoryContainerData
var pocket3 : InventoryContainerData
var pocket4 : InventoryContainerData

var head_gear : InventoryContainerData
var chest_gear : InventoryContainerData
var hands_gear : InventoryContainerData
var legs_gear : InventoryContainerData
var foot_gear : InventoryContainerData


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
	var next_tile : Vector2i = _search_next_available_tile(item)
	
	if next_tile == Vector2i(-1, -1): 
		push_warning("INVENTORY IS FULL")
		return
	if not _has_enough_space_in_grid(item, next_tile):
		push_warning("not enough space")
		return
	
	
	var item_data : ItemDataRes = item.item_data.duplicate(true)
	var inventory_container_data = InventoryContainerData.new() 
	inventory_container_data.item_data = item_data
	inventory_container_data.icon = await TextureExtractor.get_texture(item)
	
	items_data[inventory_container_data] = next_tile # TODO: should get next available
	var coord = _get_coords_from_inventory_container_data(inventory_container_data)
	_set_coord_grid(coord, inventory_container_data)

	for h in range(1, item_data.tiles_height):
		grid[h + coord.x][coord.y] = '|'

	for h in item_data.tiles_height:
		for w in range(1, item_data.tiles_width):
			grid[h + coord.x][w + coord.y] = '-'

func _has_enough_space_in_grid(item: BaseItem, vec2: Vector2i) -> bool:
	var width = item.item_data.tiles_width
	var height = item.item_data.tiles_height
	
	if width > grid.size() - vec2.y + 1: return false
	if height > grid[0].size() - vec2.x + 1: return false
	
	return true

func _search_next_available_tile(item: BaseItem) -> Vector2i:
	for row in grid.size():
		for tile in grid[0].size():
			print(Vector2i(row, tile))
			if grid[row][tile] == null and _has_enough_space_in_grid(item, Vector2i(row, tile)):
				return Vector2i(row, tile)
	return Vector2i(-1, -1)

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
