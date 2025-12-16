extends PanelContainer
class_name InventoryItemDisplay

const TILE_SIZE := 50.0

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect


var item_data : ItemDataRes
func populate(item : ItemDataRes):
	item_data = item
	custom_minimum_size = Vector2(item.tiles_width, item.tiles_height) * TILE_SIZE
	


var og_pos: Vector2
var position_offset: Vector2
var follow_mouse: bool = false:
	set(value):
		follow_mouse = value
		
		# puts this node at front of its siblings
		var parent = get_parent()
		var last_index = get_parent().get_child_count() - 1
		parent.move_child(self, last_index)
		
		# calculates mouse offset
		og_pos = position
		position_offset = -custom_minimum_size * 0.5

func _process(delta: float) -> void:
	if follow_mouse:
		global_position = get_global_mouse_position() + position_offset
