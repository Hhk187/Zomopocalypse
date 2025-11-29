extends CanvasLayer
class_name InfoGage


static var debug_dict : Dictionary[String, Variant]

func _ready() -> void:
	Global.info_gages = self



@onready var loading_icon: TextureRect = $LoadingIcon
var loading_icon_tween : Tween
func toggle_loading(value : bool):
	loading_icon.visible = value
	if value:
		loading_icon_tween = get_tree().create_tween().bind_node(loading_icon)
		loading_icon_tween.tween_property(loading_icon, "rotation_degrees", 99999, 60*10)
		loading_icon_tween.play()
