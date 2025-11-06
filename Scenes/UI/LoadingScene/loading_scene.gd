extends CanvasLayer


@export var SceneToLoad : PackedScene

var progress = []
var load_status = 0

@onready var panel_container: PanelContainer = $CenterContainer/PanelContainer
@onready var margin_container: MarginContainer = $CenterContainer/PanelContainer/MarginContainer
@onready var progress_bar: ProgressBar = $CenterContainer/PanelContainer/MarginContainer/ProgressBar

func _ready() -> void:
	ResourceLoader.load_threaded_request(SceneToLoad.resource_path)

func _process(_delta: float) -> void:
	load_status = ResourceLoader.load_threaded_get_status(SceneToLoad.resource_path, progress)
	progress_bar.value = progress[0] * 100
	
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(SceneToLoad.resource_path))
