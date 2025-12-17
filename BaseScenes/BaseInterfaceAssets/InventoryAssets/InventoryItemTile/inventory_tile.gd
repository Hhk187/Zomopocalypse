extends Panel
class_name InventoryTile


func _on_toggle_tiles_color(color : Color):
	material.set("shader_parameter/tint_color", color)
