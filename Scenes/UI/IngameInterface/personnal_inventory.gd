extends Control

var INVENTORY_TILE_SCENE: PackedScene = ResourceLoader.load("res://BaseScenes/BaseInterfaceAssets/InventoryAssets/InventoryItemTile/InventoryTile.tscn")
var INVENTORY_TILE_DISPLAY_SCENE: PackedScene = ResourceLoader.load("res://BaseScenes/BaseInterfaceAssets/InventoryAssets/InventoryItemDisplay/InventoryItemDisplay.tscn")

@onready var grid_inventory: GridContainer = $VBoxContainer/Inventory/InventorySection/GridInventory
@onready var inventory: GridContainer = $VBoxContainer/Inventory/InventorySection/Inventory




func _ready() -> void:
	_on_close_inventory()
	owner.open_inventory.connect(_on_open_inventory)
	owner.close_inventory.connect(_on_close_inventory)
	owner.toggle_inventory.connect(_on_toggle_inventory)

func _on_open_inventory(player : BaseEntity):
	get_parent().show()
	
	var players_inventory: InventoryData = player.inventory_data
	var inventory_size: Vector2i = players_inventory.get_size()

	if grid_inventory.get_child_count():
		for i in grid_inventory.get_children():
			i.queue_free()
	if inventory.get_child_count():
		for i in inventory.get_children():
			i.queue_free()
	
	
	for i in range(inventory_size.x):
		for j in range(inventory_size.y):
			grid_inventory.add_child(INVENTORY_TILE_SCENE.instantiate())
	
	for item in players_inventory.items_data:
		var item_display : InventoryItemDisplay = INVENTORY_TILE_DISPLAY_SCENE.instantiate()
		item_display.set_display_size(item.item_data)
		inventory.add_child(item_display)


func _on_close_inventory():
	get_parent().hide()


func _on_toggle_inventory(player : BaseEntity):
	if get_parent().visible:
		_on_close_inventory()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.can_look_around = true
	else:
		_on_open_inventory(player)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.can_look_around = false
