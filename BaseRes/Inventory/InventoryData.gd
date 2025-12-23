extends Node
class_name InventoryData

const DEFAULT_WIDTH := 8
const DEFAULT_HEIGHT := 5


signal move_to(
	inventory_container_data: InventoryContainerData,
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
	var next_tile : Dictionary = _search_next_available_tile(item)
	if next_tile.keys()[0] == Vector2i(-1, -1): 
		push_warning("INVENTORY IS FULL")
		return

	var item_data : ItemDataRes = item.item_data.duplicate(true)
	var inventory_container_data = InventoryContainerData.new() 
	inventory_container_data.item_data = item_data
	inventory_container_data.rotated = next_tile.values()[0]
	inventory_container_data.vec2 = next_tile.keys()[0]

	
	items_data[inventory_container_data] = next_tile.keys()[0]

	_place_item_on_grid(inventory_container_data)

	inventory_container_data.icon = await TextureExtractor.get_texture(item)


func _place_item_on_grid(inventory_container_data : InventoryContainerData):
	
	var item_data = inventory_container_data.item_data
	var coord = _get_coords_from_inventory_container_data(inventory_container_data)
	_set_coord_grid(coord, inventory_container_data)

	var width = item_data.tiles_height if inventory_container_data.rotated else item_data.tiles_width 
	var height = item_data.tiles_width if inventory_container_data.rotated else item_data.tiles_height


	for h in range(1, width):
		grid[h + coord.x][coord.y] = '|'

	for h in width:
		for w in range(1, height):
			grid[h + coord.x][w + coord.y] = '-'


### Used by the view ##############################################################

## This checks for overlapping items 
func is_overlapping_item(item_display : InventoryItemDisplay, vec2 : Vector2i) -> bool:

	var inventory_container_data : InventoryContainerData = item_display.inventory_container_data
	var item_data : ItemDataRes = inventory_container_data.item_data

	var width = item_data.tiles_height if item_display.rotated else item_data.tiles_width 
	var height = item_data.tiles_width if item_display.rotated else item_data.tiles_height
	
	# check if coords are wihtin 
	var width_available = grid[0].size() - vec2.y
	var height_available = grid.size() - vec2.x 
	Global.debug_manager.update_debug_info("not enough space", not (width <= width_available and height <= height_available))
	if not (width <= width_available and height <= height_available):
		return true
	
	var grid_array : Array # for debug purposes
	
	var return_value = false
	for i in width:
		for j in height:
			if grid[vec2.x + j][vec2.y + i] != null:
				return_value = true
			grid_array.append(grid[vec2.x + j][vec2.y + i])

	Global.debug_manager.update_debug_info("grid tiles", grid_array)
	return return_value

###########################################################################################


### Private commands ##############################################################


## [value, value] -> [enough space, rotated or not]
func _has_enough_space_in_grid(item: BaseItem, vec2: Vector2i) -> Array: 
	var width_available = grid[0].size() - vec2.y 
	var height_available = grid.size() - vec2.x
	
	var width = item.item_data.tiles_width
	var height = item.item_data.tiles_height
	
	var rotated_width = item.item_data.tiles_height
	var rotated_height = item.item_data.tiles_width


	
	Global.debug_manager.update_debug_info("width_item", width)
	Global.debug_manager.update_debug_info("hight_item", height)
	
	Global.debug_manager.update_debug_info("rotated_width_item", rotated_width)
	Global.debug_manager.update_debug_info("rotated_height_item", rotated_height)

	Global.debug_manager.update_debug_info("width_available", width_available)
	Global.debug_manager.update_debug_info("height_available", height_available)
	
	
	
	var return_value : Array = [false, false]
	
	if width <= width_available and height <= height_available:
		return [true, false]
	elif rotated_width <= width_available and rotated_height <= height_available:
		return [true, true]
	
	return return_value

func _search_next_available_tile(item: BaseItem) -> Dictionary:
	var return_value : Dictionary = {Vector2i(-1, -1) : null}
	for row in grid.size():
		for tile in grid[0].size():
			if grid[row][tile] != null: continue
			print(Vector2i(row, tile))

			var resault : Array = _has_enough_space_in_grid(item, Vector2i(row, tile))
			print(resault)
			if resault[0]:
				return_value = {Vector2i(row, tile) : resault[1]}
				return return_value

	
	return return_value


func _set_coord_grid(coord : Vector2i, data : Variant):
	grid[coord.x][coord.y] = data


###########################################################################################

func _on_move(inventory_container_data: InventoryContainerData, to_index: Vector2i):
	pass


func _get_coords_from_inventory_container_data(data : InventoryContainerData) -> Vector2i:
	return items_data[data]


func get_size() -> Vector2i:
	return Vector2i(grid[0].size(), grid.size())
