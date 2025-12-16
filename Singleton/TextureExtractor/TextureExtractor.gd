@tool
extends Node3D

@onready var top_light: SpotLight3D = $SubViewport/TopLight
@onready var front_light: SpotLight3D = $SubViewport/FrontLight



@onready var sub_viewport: SubViewport = $SubViewport
@onready var target: Marker3D = $SubViewport/Target
@onready var camera_3d: Camera3D = $SubViewport/Camera3D

@export var cached_textures: Dictionary[String, ImageTexture]

# Cycle through the array of models and create a texture for each model and save it to the disk
func get_texture(item : BaseItem) -> ImageTexture:
	if target.get_child_count():
		for i in target.get_children():
			i.queue_free()
	
	camera_3d.look_at(Vector3.ZERO)
	var key = item.item_data.name
	
	if cached_textures.has(key):
		return cached_textures[key]
	else:
		item.get_parent().remove_child(item)
		item._toggle(true)
		target.add_child(item)
		# setup camera shot
		item.position = item.item_data.offset_pos
		camera_3d.size = item.item_data.offset_camera_size
		sub_viewport.size = item.item_data.viewport_size
		
		await RenderingServer.frame_post_draw
		
		var img = sub_viewport.get_texture().get_image()
		#img.flip_x()
		var texture = ImageTexture.create_from_image(img)
		
		cached_textures[key] = texture
		
		item.call_deferred("queue_free")
		return texture



func _process(delta: float) -> void:
	camera_3d.look_at(Vector3.ZERO)
	front_light.look_at(Vector3.ZERO)
