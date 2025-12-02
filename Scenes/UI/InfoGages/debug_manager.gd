extends Control
class_name DebugManager

@onready var debug_container: VBoxContainer = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer

var debug_info : Dictionary[String, Variant] = {}


func _ready() -> void:
	Global.debug_manager = self

func update_debug_info(key : String, value : Variant) -> void:
	if not debug_info.has(key):
		var label = Label.new()
		label.name = key
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color.GREEN)

		debug_container.add_child(label)
	
	debug_info[key] = value

func get_debug_info(key : String) -> Variant:
	if debug_info.has(key):
		return debug_info[key]
	return null

func clear_debug_info() -> void:
	debug_info.clear()

func _process(_delta: float) -> void:
	for i in debug_info.keys():
		var label : Label = debug_container.get_node(i) as Label
		if label:
			label.text = str(i) + ": " + str(debug_info[i])
	update_debug_info("FPS", Engine.get_frames_per_second())
