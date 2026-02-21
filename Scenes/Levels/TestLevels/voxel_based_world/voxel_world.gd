@tool
extends Node3D

@export var chunk_scene: PackedScene # Assign your Chunk.tscn here
@export var world_size: int = 4 # How many chunks in each direction (4x4)


@export var generate : bool:
	set(value):
		if get_child_count():
			for i in get_children():
				i.queue_free()
		
		generate_world()

func _ready():
	if not Engine.is_editor_hint():
		generate_world()

func generate_world():
	for x in range(world_size):
		for z in range(world_size):
			create_chunk(x, z)

func create_chunk(x: int, z: int):
	# Instantiate the chunk
	var chunk = chunk_scene.instantiate()
	
	# Set its position
	# We multiply by 16 (CHUNK_SIZE) so they sit perfectly side-by-side
	chunk.position = Vector3(x * 16, 0, z * 16)
	
	# Add it to the world
	add_child(chunk)
	
	# Optional: Pass the global coordinates to the chunk so 
	# the noise generates correctly (seamless terrain)
	if chunk.has_method("init_chunk"):
		chunk.init_chunk(x, z)


# func _input(event):
# 	# Only edit if we click the mouse
# 	if event is InputEventMouseButton and event.pressed:
# 		if event.button_index == MOUSE_BUTTON_LEFT:
# 			do_edit_raycast(true) # Add Block
# 		elif event.button_index == MOUSE_BUTTON_RIGHT:
# 			do_edit_raycast(false) # Remove Block
