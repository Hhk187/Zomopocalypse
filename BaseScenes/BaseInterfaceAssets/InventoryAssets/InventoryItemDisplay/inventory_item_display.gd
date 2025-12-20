extends PanelContainer
class_name InventoryItemDisplay

const TILE_SIZE := 50.0

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect

var item_data : ItemDataRes

var og_pos: Vector2
var og_rot: bool:
	set(value):
		og_rot = value
		rotated = og_rot
var og_size: Vector2:
	set(value):
		og_size = value
		size = og_size

func populate(item : ItemDataRes):
	item_data = item
	custom_minimum_size = Vector2(item.tiles_width, item.tiles_height) * TILE_SIZE

var rotated : bool = false:
	set(value):
		if value != rotated:
			rotated = value
		
			_rotate()


var position_offset: Vector2
var follow_mouse: bool = false:
	set(value):
		follow_mouse = value
		
		# puts this node at front of its siblings
		var parent = get_parent()
		var last_index = get_parent().get_child_count() - 1
		parent.move_child(self, last_index)
		
		og_pos = position
		_calculate_mouse_to_center_offset()

func _process(_delta: float) -> void:
	if follow_mouse:
		global_position = lerp(global_position, get_global_mouse_position() + position_offset, 0.4)
		if Input.is_action_just_pressed("inv_rotate"):
			rotated = !rotated

func _calculate_mouse_to_center_offset():
		# calculates mouse offset
		position_offset = -custom_minimum_size * 0.5


func _rotate():
	var image : Image = texture_rect.texture.get_image()
	
	if rotated:
		image.rotate_90(CLOCKWISE)
		custom_minimum_size = Vector2(item_data.tiles_height, item_data.tiles_width) * TILE_SIZE
	else :
		image.rotate_90(COUNTERCLOCKWISE)
		custom_minimum_size = Vector2(item_data.tiles_width, item_data.tiles_height) * TILE_SIZE
	
	size = custom_minimum_size
	
	texture_rect.texture = ImageTexture.create_from_image(image)
	_calculate_mouse_to_center_offset()
