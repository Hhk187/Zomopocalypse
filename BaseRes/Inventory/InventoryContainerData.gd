extends Resource
class_name InventoryContainerData

enum TILE_TYPE {
	EMPTY,
	FILLER,
	PARENT,
	EQUIPEMENTS
}
enum CONTAINER_TYPE {
	TILE,
	ITEM,
	WEAPON,
	GEAR
}

var tile_type: TILE_TYPE = TILE_TYPE.EMPTY
var container_type: CONTAINER_TYPE = CONTAINER_TYPE.TILE


var parent : InventoryContainerData

@export var item_data: ItemDataRes
var base_item: BaseItem:
	set(value):
		base_item = value
		if base_item:
			item_data = base_item.item_data
		else :
			item_data = null

@export var vec2: Vector2i
@export var rotated: bool
@export var amount: int
@export var icon: Texture2D
