extends Control

@export var ITEM_CONTAINER_PACKED : PackedScene = load("res://BaseScenes/BaseInterfaceAssets/InventoryAssets/ItemContainer/ItemContainer.tscn")

@onready var poly_items: GridContainer = $VBoxContainer/Inventory/InventorySection/PolyItems




func _ready() -> void:
	_on_close_inventory()
	owner.open_inventory.connect(_on_open_inventory)
	owner.close_inventory.connect(_on_close_inventory)
	owner.toggle_inventory.connect(_on_toggle_inventory)

func _on_open_inventory(player : BaseEntity):
	get_parent().show()
	
	for child in poly_items.get_children() as Array[ItemContainer]:
		child.queue_free()
	
	for data in player.inventory_data.data as Array[ItemDataRes]:
		var item_container :=  ITEM_CONTAINER_PACKED.instantiate() as ItemContainer
		poly_items.add_child(item_container)
		item_container.icon.texture = data.icon


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
