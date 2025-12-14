extends CanvasLayer
class_name IngameInterface

signal open_inventory(inventory_data : InventoryData)
signal close_inventory
signal toggle_inventory


func _ready() -> void:
	Global.ingame_interface = self
