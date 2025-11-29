extends Node
class_name GameController

@onready var world_3d: Node3D = $World3D
@onready var world_2d: Node2D = $World2D
@onready var gui: CanvasLayer = $GUI

var current_3d_scene: Node3D
var current_2d_scene: Node2D
var current_gui_scene: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_controller = self
	


func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	
	var new = load(new_scene).instantiate() as CanvasLayer
	gui.add_child(new)
	current_gui_scene = new
			
func change_3d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_3d_scene:
		if delete:
			current_3d_scene.queue_free()
		elif keep_running:
			current_3d_scene.visible = false
		else:
			world_3d.remove_child(current_3d_scene)
	
	var new = load(new_scene).instantiate() as Node3D
	world_3d.add_child(new)
	current_3d_scene = new

func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
	
	var new = load(new_scene).instantiate() as Node2D
	world_2d.add_child(new)
	current_2d_scene = new
