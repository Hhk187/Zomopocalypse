extends Control

const INVENTORY_ITEM_DISPLAY = preload("uid://dqin6gxt05ret")


@export var MARKER_POS = Vector2(-170, -260)
@export var TILE_SIZE = 48
@export var SEPERATION = 2

@onready var grid: Control = $Grid
@onready var items: Control = $Items



func _ready() -> void:
	owner.open_inventory.connect(_on_open_inventory)
	#owner.close_inventory.connect(_on_close_inventory)
	#owner.toggle_inventory.connect(_on_toggle_inventory)

func _on_open_inventory(player : BaseEntity):
	var players_inventory: InventoryData = player.inventory_data
	var inventory_size: Vector2i = players_inventory.get_size()

	if grid.get_child_count():
		for i in grid.get_children():
			i.queue_free()
	if items.get_child_count():
		for i in items.get_children():
			i.queue_free()
	
	
	for i in range(inventory_size.x):
		for j in range(inventory_size.y):
			var tile := Panel.new()
			grid.add_child(tile)
			tile.position = MARKER_POS + Vector2((TILE_SIZE + SEPERATION) * i, (TILE_SIZE + SEPERATION) * j)
			
			tile.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE)
			tile.set_anchors_preset(Control.PRESET_CENTER)
	
	for inventory_container_data in players_inventory.items_data as Dictionary[InventoryContainerData, Vector2i]:
		var item_display : InventoryItemDisplay = INVENTORY_ITEM_DISPLAY.instantiate()
		item_display.set_display_size(inventory_container_data.item_data)
		items.add_child(item_display)
		
		item_display.position = MARKER_POS
		item_display.texture_rect.texture = inventory_container_data.icon
