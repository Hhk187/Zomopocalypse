extends PanelContainer
class_name InventoryItemDisplay

const TILE_SIZE := 50.0
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect


func set_display_size(item : ItemDataRes):
	custom_minimum_size = Vector2(item.tiles_width, item.tiles_height) * TILE_SIZE
