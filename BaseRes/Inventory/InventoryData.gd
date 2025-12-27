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




var inventory_grid: Array[Array]

var backpack_grid: Array[Array]


var weapon1:= InventoryContainerData.new()
var weapon2:= InventoryContainerData.new()
var weapon3:= InventoryContainerData.new()
var pocket1:= InventoryContainerData.new()
var pocket2:= InventoryContainerData.new()
var pocket3:= InventoryContainerData.new()
var pocket4:= InventoryContainerData.new()
var pocket5:= InventoryContainerData.new()
var pocket6:= InventoryContainerData.new()

var head:= InventoryContainerData.new()
var chest:= InventoryContainerData.new()
var hands:= InventoryContainerData.new()
var legs:= InventoryContainerData.new()
var foot:= InventoryContainerData.new()


var equipements: Array[InventoryContainerData] = [
	weapon1,
	weapon2,
	weapon3,
	pocket1,
	pocket2,
	pocket3,
	pocket4,
	head,
	chest,
	hands,
	legs,
	foot
]

var weapon_containers: Array[InventoryContainerData] = [
	weapon1,
	weapon2,
	weapon3
]

var pocket_containers: Array[InventoryContainerData] = [
	pocket1,
	pocket2,
	pocket3,
	pocket4,
	pocket5,
	pocket6
]

var gear_containers: Array[InventoryContainerData] = [
	head,
	chest,
	hands,
	legs,
	foot
]


func _ready() -> void:
	_populate_data()
	# move_to.connect(_on_move_to)
	add.connect(_on_add)


func _populate_data():
	if inventory_grid.is_empty():
		for row in DEFAULT_HEIGHT:
			inventory_grid.append([])
			for column in DEFAULT_WIDTH:
				var _inventory_container_data: InventoryContainerData = InventoryContainerData.new()
				inventory_grid[row].append(_inventory_container_data)
				_inventory_container_data.vec2 = Vector2i(row, column)
	
	for container in equipements:
		container.tile_type = InventoryContainerData.TILE_TYPE.EQUIPEMENTS

	for container in weapon_containers:
		container.container_type = InventoryContainerData.CONTAINER_TYPE.WEAPON
	
	for container in pocket_containers:
		container.container_type = InventoryContainerData.CONTAINER_TYPE.ITEM
	
	for container in gear_containers:
		container.container_type = InventoryContainerData.CONTAINER_TYPE.GEAR




func _on_add(item: BaseItem):
	var next_tile : Dictionary = _search_next_available_tile(item)
	if next_tile.keys()[0] == Vector2i(-1, -1): 
		push_warning("INVENTORY IS FULL")
		return

	var coord: Vector2i = next_tile.keys()[0]

	var item_data : ItemDataRes = item.item_data.duplicate(true)
	var inventory_container_data = inventory_grid[coord.x][coord.y]
	inventory_container_data.tile_type = InventoryContainerData.TILE_TYPE.PARENT
	inventory_container_data.item_data = item_data
	inventory_container_data.rotated = next_tile.values()[0]

	
	

	_place_item_on_inventory_grid(inventory_container_data)

	inventory_container_data.icon = await TextureExtractor.get_texture(item)


func _place_item_on_inventory_grid(inventory_container_data : InventoryContainerData):
	
	var item_data = inventory_container_data.item_data
	var coord = inventory_container_data.vec2

	var width = item_data.tiles_width if inventory_container_data.rotated else item_data.tiles_height 
	var height = item_data.tiles_height if inventory_container_data.rotated else item_data.tiles_width


	for h in width:
		var _inventory_container_data: InventoryContainerData = inventory_grid[h + coord.x][coord.y]
		_inventory_container_data.tile_type = InventoryContainerData.TILE_TYPE.FILLER
		_inventory_container_data.parent = inventory_container_data

	for h in width:
		for w in height:
			var _inventory_container_data: InventoryContainerData = inventory_grid[h + coord.x][w + coord.y]
			_inventory_container_data.tile_type = InventoryContainerData.TILE_TYPE.FILLER
			_inventory_container_data.parent = inventory_container_data

	inventory_container_data.tile_type = InventoryContainerData.TILE_TYPE.PARENT

### Used by the view ##############################################################

## This checks for overlapping items 
func is_overlapping_item(item_display : InventoryItemDisplay, vec2 : Vector2i) -> bool:

	var inventory_container_data : InventoryContainerData = item_display.inventory_container_data
	var item_data : ItemDataRes = inventory_container_data.item_data

	var width = item_data.tiles_height if item_display.rotated else item_data.tiles_width 
	var height = item_data.tiles_width if item_display.rotated else item_data.tiles_height
	
	# check if coords are wihtin 
	var width_available = inventory_grid[0].size() - vec2.y 
	var height_available = inventory_grid.size() - vec2.x 

	if not (width <= width_available and height <= height_available):
		return true
	
	var return_value = false
	var legal_array : Array[bool]
	for i in width:
		for j in height:
			var _inventory_container_data: InventoryContainerData = inventory_grid[vec2.x + j][vec2.y + i]
			
			if not _inventory_container_data: continue

			if _inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.EMPTY:
				return_value = true
			if (
				_inventory_container_data.parent == inventory_container_data
				and (_inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.FILLER
				or _inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.PARENT)
				):
				return_value = false
			
			legal_array.append(return_value)
			
			Global.debug_manager.update_debug_info("not empty tiles", _inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.EMPTY)
			Global.debug_manager.update_debug_info("same item overlapp", (
				_inventory_container_data.parent == inventory_container_data
				and (_inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.FILLER
				or _inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.PARENT)
				))
			

		
	return_value = true in legal_array

	return return_value

###########################################################################################


### Private commands ##############################################################


## [value, value] -> [enough space, rotated or not]
func _has_enough_space_in_inventory_grid(item: BaseItem, vec2: Vector2i) -> Array: 
	var width_available = inventory_grid[0].size() - vec2.y 
	var height_available = inventory_grid.size() - vec2.x 
	
	var width = item.item_data.tiles_width
	var height = item.item_data.tiles_height
	
	var rotated_width = item.item_data.tiles_height
	var rotated_height = item.item_data.tiles_width
	
	
	var return_value : Array = [false, false]
	
	if width <= width_available and height <= height_available:
		return_value = [true, false]
	elif rotated_width <= width_available and rotated_height <= height_available:
		return_value = [true, true]
	
	width = rotated_width if return_value[1] else width
	height = rotated_height if return_value[1] else height

	if return_value[0]:
		for i in width:
			for j in height:
				var _inventory_container_data: InventoryContainerData = inventory_grid[vec2.x + j][vec2.y + i]
				
				if not _inventory_container_data: continue

				if _inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.EMPTY:
					return_value[0] = false




	return return_value

func _search_next_available_tile(item: BaseItem) -> Dictionary:
	var return_value : Dictionary = {Vector2i(-1, -1) : null}
	for row in inventory_grid.size():
		for tile in inventory_grid[0].size():
			var _inventory_container_data: InventoryContainerData = inventory_grid[row][tile]
			if _inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.EMPTY: continue
			print(Vector2i(row, tile))

			var resault : Array = _has_enough_space_in_inventory_grid(item, Vector2i(row, tile))
			
			print(resault)
			if resault[0]:
				return_value = {Vector2i(row, tile) : resault[1]}
				return return_value

	
	return return_value


func _set_coord_inventory_grid(coord : Vector2i, data : Variant):
	inventory_grid[coord.x][coord.y] = data


###########################################################################################

func _on_remove(inventory_container_data: InventoryContainerData):
	var item_data = inventory_container_data.item_data
	var coord = inventory_container_data.vec2

	var width = item_data.tiles_width if inventory_container_data.rotated else item_data.tiles_height 
	var height = item_data.tiles_height if inventory_container_data.rotated else item_data.tiles_width

	
	
	for h in width:
		var _inventory_container_data: InventoryContainerData = inventory_grid[h + coord.x][coord.y]
		_inventory_container_data.tile_type = InventoryContainerData.TILE_TYPE.EMPTY
		_inventory_container_data.parent = null

	for h in width:
		for w in height:
			var _inventory_container_data: InventoryContainerData = inventory_grid[h + coord.x][w + coord.y]
			_inventory_container_data.tile_type = InventoryContainerData.TILE_TYPE.EMPTY
			_inventory_container_data.parent = null



func _on_move(item_display: InventoryItemDisplay, to_index: Vector2i):
	var inventory_container_data: InventoryContainerData = item_display.inventory_container_data
	
	var item_data: ItemDataRes = inventory_container_data.item_data
	var old_amount: int = inventory_container_data.amount
	var old_icon: Texture2D = inventory_container_data.icon
	
	_on_remove(inventory_container_data)


	var new_inventory_container_data: InventoryContainerData = inventory_grid[to_index.x][to_index.y]
	new_inventory_container_data.item_data = item_data

	new_inventory_container_data.rotated = item_display.rotated
	new_inventory_container_data.amount = old_amount
	new_inventory_container_data.icon = old_icon

	_place_item_on_inventory_grid(new_inventory_container_data)



func get_size() -> Vector2i:
	return Vector2i(inventory_grid[0].size(), inventory_grid.size())
