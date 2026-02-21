extends Node3D

@onready var camera = get_viewport().get_camera_3d()
const RAY_LENGTH = 10.0
const CHUNK_SIZE = 16 # Must match your chunk size

# Current selected block (1=Wood, 2=Brick, 3=Rust)
var current_block_id: int = 1 

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			shoot_ray(false) # Remove
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			shoot_ray(true) # Add
	
	# Block Selection
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1: current_block_id = 1
		if event.keycode == KEY_2: current_block_id = 2
		if event.keycode == KEY_3: current_block_id = 3

func shoot_ray(add: bool):
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space.intersect_ray(query)
	
	if result:
		var hit_pos = result.position
		var normal = result.normal
		
		# 1. Calculate the center of the block we want to edit in GLOBAL space
		var target_global_pos = hit_pos
		
		if add:
			target_global_pos += (normal * 0.5) # Move INTO the empty space
		else:
			target_global_pos -= (normal * 0.5) # Move INTO the existing block
			
		# 2. Identify which Chunk this global position belongs to
		# (This assumes your chunks are placed at x*16, 0, z*16)
		
		var chunk_x = int(floor(target_global_pos.x / CHUNK_SIZE))
		var chunk_z = int(floor(target_global_pos.z / CHUNK_SIZE))
		
		# 3. Calculate Local Coordinates inside that chunk
		# Use modulo (%) to wrap 17 -> 1, 32 -> 0, etc.
		var local_x = int(floor(target_global_pos.x)) % CHUNK_SIZE
		var local_y = int(floor(target_global_pos.y))
		var local_z = int(floor(target_global_pos.z)) % CHUNK_SIZE
		
		# Fix negative modulo bug (Godot % can return negative for negative numbers)
		if local_x < 0: local_x += CHUNK_SIZE
		if local_z < 0: local_z += CHUNK_SIZE

		# 4. Find the Chunk Node
		var chunk_node = find_chunk_by_coords(chunk_x, chunk_z)
		
		if chunk_node:
			# 5. Execute the update directly
			if add:
				chunk_node.set_block(local_x, local_y, local_z, current_block_id)
			else:
				chunk_node.set_block(local_x, local_y, local_z, 0)
			
			chunk_node.update_mesh()
			
			# Re-generate collision immediately so we can click it again
			if chunk_node.get_child_count() > 0: chunk_node.get_child(0).queue_free()
			chunk_node.create_trimesh_collision()

func find_chunk_by_coords(cx: int, cz: int) -> Node:
	# This part depends on where your chunks are stored.
	# If you have a "World" node, search its children.
	# Assuming chunks are children of a node named "VoxelWorld"
	
	var world = get_tree().current_scene.find_child("VoxelWorld", true, false)
	if not world: return null
	
	for child in world.get_children():
		# You need to expose these variables in Chunk.gd or check position
		if child.get("chunk_x") == cx and child.get("chunk_z") == cz:
			return child
			
	# Fallback: Create new chunk if it doesn't exist? (Optional)
	return null
