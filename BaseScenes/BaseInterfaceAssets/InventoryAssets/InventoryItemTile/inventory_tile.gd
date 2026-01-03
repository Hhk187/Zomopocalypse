extends Panel
class_name InventoryTile


const HOVERED_COLOR_GREEN = Color(Color.FOREST_GREEN, 0.7)
const HOVERED_COLOR_RED = Color(Color.DARK_RED, 0.7)
const HOVERED_COLOR_DEFAULT = Color(Color.DIM_GRAY, 0.5)

@export var occupied: bool
@export var is_rotated : bool

@export_enum(
	ConstItemType.TYPE_WEAPON_ONE_HANDED,
	ConstItemType.TYPE_WEAPON_TWO_HANDED,
	ConstItemType.TYPE_CONSUMABLE,
	ConstItemType.TYPE_GEAR,
	ConstItemType.TYPE_ITEM
	) var item_type


func _on_toggle_tiles_color(color : Color):
	material.set("shader_parameter/tint_color", color)


func _ready() -> void:
	material = material.duplicate(true)
	material.set("shader_parameter/tint_color", HOVERED_COLOR_DEFAULT)
