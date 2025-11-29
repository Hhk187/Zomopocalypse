extends Node
class_name GameController

var paused: bool = false

enum COMMANDS {
	KEEP,
	DELETE,
	REMOVE,
	HIDE
}

const SCENES : Dictionary = {
	"3d" : {
		"intro" : "res://Scenes/IntroScene/intro_scene.tscn",
		"city" : "res://Scenes/Levels/TestLevels/City2/City2.tscn",
	},
	"2d" : {
		"hud" : "res://Scenes/HUD/hud_scene.tscn"
	},
	"gui" : {
		"main_menu" : "res://Scenes/UI/MainMenu/MainMenu.tscn",
		"ingame_menu" : "res://Scenes/UI/IngameMenu/IngameMenu.tscn",
		"info_gages" : "res://Scenes/UI/InfoGages/InfoGages.tscn"
	}
}

@onready var parent_nodes: Dictionary = {
	"3d": $World3D,
	"2d": $World2D,
	"gui": $GUI
}

var current_scenes: Dictionary = {
	"3d": null,
	"2d": null,
	"gui": null
}

var cached_scenes: Dictionary[String, Node] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_controller = self
	change_scene(SCENES["gui"]["info_gages"], "gui")
	change_scene(SCENES["3d"]["intro"], "3d")


func change_scene(path: String, category : String, command: GameController.COMMANDS = COMMANDS.KEEP) -> void:
	# Start a thread to handle the scene change
	var thread = Thread.new()
	thread.start(_threaded_change_scene.bind([path, category, command]))
	await thread.wait_to_finish()


# Threaded scene change logic
func _threaded_change_scene(args: Array) -> void:
	var path = args[0]
	var category = args[1]
	var command = args[2]

	# Show loading at start (on main thread)
	call_deferred("_show_loading")

	# Simulate a small delay for loading effect (optional, remove if not needed)
	# OS.delay_msec(500)  # Uncomment for visible loading

	# Handle current scene (must use call_deferred for scene tree changes)
	if current_scenes[category]:
		match command:
			COMMANDS.DELETE:
				call_deferred("_queue_free_and_erase", current_scenes[category], current_scenes[category].filename)
			COMMANDS.HIDE:
				call_deferred("_set_visible", current_scenes[category], false)
			COMMANDS.REMOVE:
				call_deferred("_remove_child", parent_nodes[category], current_scenes[category])

	# Wait for deferred calls to process
	await get_tree().process_frame

	# Load new scene from cache or disk
	if cached_scenes.has(path):
		if not parent_nodes[category].has_node(cached_scenes[path].name):
			call_deferred("_add_child", parent_nodes[category], cached_scenes[path])
		current_scenes[category] = cached_scenes[path]
		call_deferred("_set_visible", current_scenes[category], true)
	else:
		var new = ResourceLoader.load(path).instantiate()
		cached_scenes[path] = new
		call_deferred("_add_child", parent_nodes[category], new)
		current_scenes[category] = new

	# Wait for deferred calls to process
	await get_tree().process_frame

	# Hide loading at end (on main thread)
	call_deferred("_hide_loading")

# Helper methods for thread-safe scene tree changes
func _show_loading():
	if Global.info_gages:
		Global.info_gages.toggle_loading(true)

func _hide_loading():
	if Global.info_gages:
		Global.info_gages.toggle_loading(false)

func _queue_free_and_erase(node: Node, filename: String):
	if node:
		node.queue_free()
	if cached_scenes.has(filename):
		cached_scenes.erase(filename)

func _set_visible(node: Node, visible: bool):
	if node:
		node.visible = visible

func _remove_child(parent: Node, child: Node):
	if parent and child:
		parent.remove_child(child)

func _add_child(parent: Node, child: Node):
	if parent and child and not child.get_owner():
		parent.add_child(child)

func get_scene(path: String) -> Variant:
	if cached_scenes.has(path):
		return cached_scenes[path]
	else:
		return null
