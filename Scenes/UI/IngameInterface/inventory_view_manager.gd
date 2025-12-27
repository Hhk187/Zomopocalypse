extends Control
class_name InventoryViewManager

signal toggle_tiles_color(switch : Color)

const INVENTORY_ITEM_DISPLAY = preload("uid://dqin6gxt05ret")
const INVENTORY_TILE = preload("uid://bkqajk4bjyhkk")


const MARKER_POS = Vector2(-170, -260)
const TILE_SIZE = 48
const SEPERATION = 2
const INVENTORY_WIDTH = 8
const INVENTORY_HEIGHT = 5


 

var players_inventory : InventoryData
@onready var grid: Control = $GridInventory/Grid
@onready var items: Control = $GridInventory/Items
@onready var equipements: Control = $Equipements
@onready var character_view: Control = $CharacterView



func _ready() -> void:
	owner.open_inventory.connect(_on_open_inventory)
	owner.close_inventory.connect(_on_close_inventory)
	#owner.toggle_inventory.connect(_on_toggle_inventory)

	for tile in equipements.get_children() as Array[InventoryTile]:
		if not toggle_tiles_color.is_connected(tile._on_toggle_tiles_color):
			connect("toggle_tiles_color", tile._on_toggle_tiles_color)
		
	

## Updating inventory view ##############################################################
func _on_open_inventory(player : BaseEntity):
	players_inventory = player.inventory_data
	var inventory_size: Vector2i = players_inventory.get_size()
	
	if grid.get_child_count():
		for i in grid.get_children():
			i.queue_free()
	if items.get_child_count():
		for i in items.get_children():
			i.queue_free()
	
	# grid display
	for i in range(inventory_size.y):
		for j in range(inventory_size.x):
			var tile : InventoryTile = INVENTORY_TILE.instantiate()
			connect("toggle_tiles_color", tile._on_toggle_tiles_color)
			tile._on_toggle_tiles_color(InventoryTile.HOVERED_COLOR_DEFAULT)
			
			grid.add_child(tile)
			tile.position = MARKER_POS + Vector2((TILE_SIZE + SEPERATION) * j, (TILE_SIZE + SEPERATION) * i)
			tile.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE)
			tile.size = custom_minimum_size
	
	# equipements
	for index in equipements.get_child_count():
		var inventory_container_data: InventoryContainerData = players_inventory.equipements[index]
		var equipement_tile: InventoryTile = equipements.get_child(index)

		
		if inventory_container_data.tile_type != InventoryContainerData.TILE_TYPE.EQUIPEMENTS: continue
		
		var item_display : InventoryItemDisplay = INVENTORY_ITEM_DISPLAY.instantiate()
		items.add_child(item_display)
		
		item_display.populate(inventory_container_data)
		# connecting to input for interactions on "_on_item1_clicked"
		item_display.connect("gui_input", _on_item_clicked.bind(item_display))
		
		item_display.texture_rect.texture = inventory_container_data.icon
		item_display.og_rot = equipement_tile.is_rotated
		item_display.global_position = equipement_tile.global_position
		item_display.og_size = equipement_tile.size



	
	
	
	for i in players_inventory.inventory_grid.size():
		for j in players_inventory.inventory_grid[0].size():
			var inventory_container_data: InventoryContainerData = players_inventory.inventory_grid[i][j]
			if inventory_container_data.tile_type == InventoryContainerData.TILE_TYPE.PARENT:
				var item_display : InventoryItemDisplay = INVENTORY_ITEM_DISPLAY.instantiate()
				items.add_child(item_display)
				
				item_display.populate(inventory_container_data)
				# connecting to input for interactions on "_on_item1_clicked"
				item_display.connect("gui_input", _on_item_clicked.bind(item_display))
				
				item_display.position = grid.get_child(j + i * INVENTORY_WIDTH).position - Vector2(SEPERATION, SEPERATION) * 0.5
				item_display.texture_rect.texture = inventory_container_data.icon
				item_display.rotated = inventory_container_data.rotated


	### DEBUG ###

	var temp_array : Array
	for i in players_inventory.inventory_grid.size():
		temp_array.append([])
		for j in players_inventory.inventory_grid[0].size():
			temp_array[i].append(players_inventory.inventory_grid[i][j].tile_type)

	for i in temp_array.size():
		Global.debug_manager.update_debug_info(str(i), temp_array[i])
	
	for index in players_inventory.equipements.size():
		if players_inventory.equipements[index].item_data:
			Global.debug_manager.update_debug_info("equipement %d" % [index], players_inventory.equipements[index].item_data.name)
		else:
			Global.debug_manager.update_debug_info("equipement %d" % [index], players_inventory.equipements[index].tile_type)

	#############

func _on_close_inventory():
	if grid.get_child_count():
		for i in grid.get_children():
			i.queue_free()
	if items.get_child_count():
		for i in items.get_children():
			i.queue_free()
	
	if selected_item:
		selected_item.follow_mouse = false
		selected_item = null

##############################################################



### Tile search ##############################################################

func get_tile_index_from_pos(pos : Vector2) -> Vector2i:
	var real_pos = Vector2i(pos - grid.get_child(0).global_position)

	if real_pos.x < 0 or real_pos.y < 0: return Vector2i(-1, -1)
	var x = real_pos.x / 50
	var y = (real_pos.y / 50) 
	
	if x > INVENTORY_WIDTH -1 or y > INVENTORY_HEIGHT - 1:
		return Vector2i(-1, -1)
	
	
	return Vector2i(x, y)


func get_tile_from_index(pos : Vector2) -> Panel:
	var vec2 : Vector2i = pos
	if vec2 == Vector2i(-1, -1) or vec2.x > INVENTORY_WIDTH -1 or vec2.y > INVENTORY_HEIGHT - 1:
		return null
	
	return grid.get_child(vec2.x + vec2.y * INVENTORY_WIDTH)


func get_tile_from_pos(pos : Vector2) -> Panel:
	var vec2 : Vector2i = get_tile_index_from_pos(pos)
	return get_tile_from_index(vec2)

##############################################################


### Tile highlighting ##############################################################

func highlight_hovered_tiles() -> bool:
	var tiles_array : Array[InventoryTile]
	
	var index_tile_vec2 = get_tile_index_from_pos(selected_item.global_position + Vector2(TILE_SIZE*0.5, TILE_SIZE*0.5))
	if index_tile_vec2 == Vector2i(-1, -1):
		return false
	
	var item_tiles_width : int = selected_item.item_data.tiles_width
	var item_tiles_height : int = selected_item.item_data.tiles_height
	
	for width in item_tiles_width:
		for height in item_tiles_height:
			var tile : InventoryTile
			
			if selected_item.rotated:
				tile = get_tile_from_index(Vector2(index_tile_vec2.x + height, index_tile_vec2.y + width))
			else :
				tile = get_tile_from_index(Vector2(index_tile_vec2.x + width, index_tile_vec2.y + height))
	
			tiles_array.append(tile)
	
	
	# checking for nulls
	var OK : bool = true
	var overlapping : bool = players_inventory.is_overlapping_item(
		selected_item, 
		Vector2i(index_tile_vec2.y, index_tile_vec2.x)
		)
	
	Global.debug_manager.update_debug_info("overlapping item", overlapping)
	Global.debug_manager.update_debug_info("index pos", index_tile_vec2)
	for tile in tiles_array:
		if tile == null:
			OK = false
			return false

	
	if not overlapping:
		for tile in tiles_array: 
			tile._on_toggle_tiles_color(InventoryTile.HOVERED_COLOR_GREEN)
		return true
	
	else :
		for tile in tiles_array: 
			tile._on_toggle_tiles_color(InventoryTile.HOVERED_COLOR_RED)
		return false
	
	
## TODO : make it so equipement slot dont overwrite each other 

func highlight_hovered_equipement_slots() -> Panel:
	for slot in equipements.get_children() as Array[InventoryTile]:
		var top_left_pos = slot.global_position
		var bottom_right_pos = top_left_pos + slot.size
		
		if (
			top_left_pos.x < get_global_mouse_position().x and top_left_pos.y < get_global_mouse_position().y 
			and bottom_right_pos.x > get_global_mouse_position().x and bottom_right_pos.y > get_global_mouse_position().y
			):
			slot._on_toggle_tiles_color(InventoryTile.HOVERED_COLOR_GREEN)
			return slot
	
	return 

##############################################################



## Verifies and places the item display if its legal ##############################################################
func can_and_place_item(item_display : InventoryItemDisplay):
	
	
	var tile : InventoryTile = get_tile_from_pos(item_display.global_position + Vector2(TILE_SIZE*0.5, TILE_SIZE*0.5)) # top left of the item display is the selector
	var is_legal = highlight_hovered_tiles()
	
	var equipement_tile : InventoryTile = highlight_hovered_equipement_slots()
	var index_tile_vec2 = get_tile_index_from_pos(selected_item.global_position + Vector2(TILE_SIZE*0.5, TILE_SIZE*0.5))
	


	if equipement_tile:
		item_display.og_rot = equipement_tile.is_rotated
		item_display.global_position = equipement_tile.global_position
		item_display.og_size = equipement_tile.size

		players_inventory._on_equip(item_display, equipement_tile.get_index())
		
	elif tile and is_legal:
		item_display.og_rot = item_display.rotated
		item_display.global_position = tile.global_position - Vector2(SEPERATION, SEPERATION) * 0.5 # applying offset seperation
		item_display.og_size = item_display.custom_minimum_size

		players_inventory._on_move(
			selected_item,
			Vector2i(index_tile_vec2.y, index_tile_vec2.x)
			)
	else:
		item_display.rotated = item_display.og_rot
		item_display.position = item_display.og_pos
		item_display.size = item_display.og_size
	
	
	item_display.follow_mouse = false
	selected_item = null
	toggle_tiles_color.emit(InventoryTile.HOVERED_COLOR_DEFAULT)

############################################################################################################################

var selected_item: InventoryItemDisplay
## Connected to InventoryItemDisplay instances
func _on_item_clicked(event : InputEvent, item_display : InventoryItemDisplay):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			selected_item = item_display
			item_display.follow_mouse = true
			item_display.size = get_minimum_size()

		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			if selected_item:
				can_and_place_item(selected_item)
			_on_open_inventory(players_inventory.get_parent())
			


		
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			item_display.follow_mouse = false
			players_inventory._on_remove(item_display.inventory_container_data)
			_on_open_inventory(players_inventory.get_parent())

func _process(_delta: float) -> void:
	if selected_item:
		toggle_tiles_color.emit(InventoryTile.HOVERED_COLOR_DEFAULT)
		highlight_hovered_tiles()
		highlight_hovered_equipement_slots()
