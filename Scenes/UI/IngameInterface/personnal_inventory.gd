extends Control

@onready var personnal_inventory: PanelContainer = $PersonnalInventory



func _ready() -> void:
	get_parent().open_inventory.connect(_on_open_inventory)
	get_parent().close_inventory.connect(_on_close_inventory)
	get_parent().toggle_inventory.connect(_on_toggle_inventory)

func _on_open_inventory():
	personnal_inventory.show()

func _on_close_inventory():
	personnal_inventory.hide()

func _on_toggle_inventory():
	personnal_inventory.visible = !personnal_inventory.visible
