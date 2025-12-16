extends Control

const INVENTORY_ITEM_DISPLAY = preload("uid://dqin6gxt05ret")


const MARKER_POS = Vector2(-170, -260)
const TILE_SIZE = Vector2(50, 50)
const SEPERATION = 1
const INVENTORY_WIDTH = 8

var players_inventory : InventoryData

@onready var grid: Control = $Grid
@onready var items: Control = $Items



func _ready() -> void:
	owner.open_inventory.connect(_on_open_inventory)
	#owner.close_inventory.connect(_on_close_inventory)
	#owner.toggle_inventory.connect(_on_toggle_inventory)

## Updating inventory view
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
			var tile := Panel.new()
			
			grid.add_child(tile)
			tile.position = MARKER_POS + Vector2((TILE_SIZE.x + SEPERATION) * j, (TILE_SIZE.y + SEPERATION) * i)
			tile.custom_minimum_size = TILE_SIZE
	
	
	for i in players_inventory.grid.size():
		for j in players_inventory.grid[0].size():
			Global.debug_manager.update_debug_info(str(i), players_inventory.grid[i])
			if players_inventory.grid[i][j] is InventoryContainerData:
				var inventory_container_data : InventoryContainerData = players_inventory.grid[i][j]
				var item_display : InventoryItemDisplay = INVENTORY_ITEM_DISPLAY.instantiate()
				items.add_child(item_display)
				
				item_display.populate(inventory_container_data.item_data)
				# connecting to input for interactions on "_on_item1_clicked"
				item_display.connect("gui_input", _on_item_clicked.bind(item_display))
				
				item_display.position = grid.get_child(j + i * INVENTORY_WIDTH).position
				item_display.texture_rect.texture = inventory_container_data.icon

func get_tile_from_mouse_pos(pos : Vector2):
	var real_pos = Vector2i(pos - grid.get_child(0).global_position)
	if real_pos.x < 0 or real_pos.y < 0: return

	var x = real_pos.x / 50
	var y = (real_pos.y / 50) 
	
	
	return [grid.get_child(x + y * INVENTORY_WIDTH), Vector2i(x, y)]

var selected_item : InventoryItemDisplay
## Connected to InventoryItemDisplay instances
func _on_item_clicked(event : InputEvent, item_display : InventoryItemDisplay):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			selected_item = item_display
			item_display.follow_mouse = true
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			if get_tile_from_mouse_pos(get_global_mouse_position()):
				item_display.position = get_tile_from_mouse_pos(get_global_mouse_position())[0].position
				players_inventory._on_move()
			else:
				item_display.position = item_display.og_pos
			item_display.follow_mouse = false
