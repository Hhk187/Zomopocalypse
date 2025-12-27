extends Panel
class_name InventoryTile


@export var occupied: bool
@export var is_rotated : bool

@export_enum(
	ConstItemType.TYPE_WEAPON,
	ConstItemType.TYPE_CONSUMABLE,
	ConstItemType.TYPE_GEAR,
	ConstItemType.TYPE_ITEM
	) var item_type


func _on_toggle_tiles_color(color : Color):
	material.set("shader_parameter/tint_color", color)


func _ready() -> void:
	material = material.duplicate(true)