@tool
extends MeshInstance3D

@export var gen : bool:
	set(value):
		init_chunk(0, 0)

# --- Configuration ---
const CHUNK_SIZE = 16
const BLOCK_SCALE = 1.0

# --- Texture Atlas Settings ---
# You said you have 3 textures in 1 row.
const ATLAS_GRID_SIZE = Vector2(3, 1) # 3 Columns, 1 Row

# Calculate UV size per block
const UV_WIDTH = 1.0 / ATLAS_GRID_SIZE.x
const UV_HEIGHT = 1.0 / ATLAS_GRID_SIZE.y

# --- Data ---
var block_data: PackedByteArray = PackedByteArray()

# DEFINE YOUR BLOCKS HERE
# Coordinates are grid positions (Col, Row)
var BLOCK_TYPES = {
	1: { "all": Vector2(0, 0) },     # 1st Image (Wood)
	2: { "all": Vector2(1, 0) },     # 2nd Image (Brick)
	3: { "all": Vector2(2, 0) },     # 3rd Image (Rust)
}

# --- Surface Tool ---
var st = SurfaceTool.new()
var chunk_x: int = 0
var chunk_z: int = 0
var noise = FastNoiseLite.new()

func _ready():
	block_data.resize(CHUNK_SIZE * CHUNK_SIZE * CHUNK_SIZE)
	# Default init (creates flat floor)
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			set_block(x, 0, z, 1)
	update_mesh()

func init_chunk(x_coord, z_coord):
	chunk_x = x_coord
	chunk_z = z_coord
	generate_terrain()
	update_mesh()
	# Ensure collision child exists before recreating it
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
	create_trimesh_collision()

func generate_terrain():
	# ... (Your existing terrain logic is fine) ...
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			var global_x = (chunk_x * CHUNK_SIZE) + x
			var global_z = (chunk_z * CHUNK_SIZE) + z
			var noise_val = noise.get_noise_2d(global_x, global_z)
			var height = int((noise_val * 10) + 5)
			
			for y in range(CHUNK_SIZE):
				if y < height:
					if y == height - 1: set_block(x, y, z, 1)
					elif y > height - 4: set_block(x, y, z, 2)
					else: set_block(x, y, z, 3)
				else:
					set_block(x, y, z, 0)

func get_block(x: int, y: int, z: int) -> int:
	if x < 0 or x >= CHUNK_SIZE or y < 0 or y >= CHUNK_SIZE or z < 0 or z >= CHUNK_SIZE:
		return 0
	return block_data[x + y * CHUNK_SIZE + z * CHUNK_SIZE * CHUNK_SIZE]

func set_block(x: int, y: int, z: int, id: int):
	block_data[x + y * CHUNK_SIZE + z * CHUNK_SIZE * CHUNK_SIZE] = id

func update_mesh():
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			for z in range(CHUNK_SIZE):
				var block_id = get_block(x, y, z)
				if block_id != 0:
					create_block(x, y, z, block_id)
	
	st.generate_normals()
	mesh = st.commit()

func create_block(x: int, y: int, z: int, block_id: int):
	var pos = Vector3(x, y, z) * BLOCK_SCALE
	
	if get_block(x, y + 1, z) == 0: build_face(pos, Vector3(0, 1, 0), block_id)
	if get_block(x, y - 1, z) == 0: build_face(pos, Vector3(0, -1, 0), block_id)
	if get_block(x, y, z + 1) == 0: build_face(pos, Vector3(0, 0, 1), block_id)
	if get_block(x, y, z - 1) == 0: build_face(pos, Vector3(0, 0, -1), block_id)
	if get_block(x + 1, y, z) == 0: build_face(pos, Vector3(1, 0, 0), block_id)
	if get_block(x - 1, y, z) == 0: build_face(pos, Vector3(-1, 0, 0), block_id)

func build_face(pos: Vector3, normal: Vector3, block_id: int):
	# 1. Get UV Offset from Dictionary
	var atlas_pos = Vector2(0, 0)
	if BLOCK_TYPES.has(block_id):
		atlas_pos = BLOCK_TYPES[block_id]["all"]
	
	# 2. Calculate UV Corners based on Grid Position
	var uv_x_start = atlas_pos.x * UV_WIDTH
	var uv_x_end = uv_x_start + UV_WIDTH
	
	var uv_y_start = atlas_pos.y * UV_HEIGHT
	var uv_y_end = uv_y_start + UV_HEIGHT
	
	# Define corners
	var uv_top_left = Vector2(uv_x_start, uv_y_start)
	var uv_top_right = Vector2(uv_x_end, uv_y_start)
	var uv_bot_left = Vector2(uv_x_start, uv_y_end)
	var uv_bot_right = Vector2(uv_x_end, uv_y_end)

	st.set_normal(normal)
	
	# 3. Add Vertices
	if normal == Vector3(0, 1, 0): # TOP
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(0, 1, 0))
		st.set_uv(uv_top_right); st.add_vertex(pos + Vector3(1, 1, 0))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(1, 1, 1))
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(0, 1, 0))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(1, 1, 1))
		st.set_uv(uv_bot_left);  st.add_vertex(pos + Vector3(0, 1, 1))

	elif normal == Vector3(0, -1, 0): # BOTTOM
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(0, 0, 1))
		st.set_uv(uv_top_right); st.add_vertex(pos + Vector3(1, 0, 1))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(1, 0, 0))
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(0, 0, 1))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(1, 0, 0))
		st.set_uv(uv_bot_left);  st.add_vertex(pos + Vector3(0, 0, 0))

	elif normal == Vector3(0, 0, 1): # FRONT
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(0, 1, 1))
		st.set_uv(uv_top_right); st.add_vertex(pos + Vector3(1, 1, 1))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(1, 0, 1))
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(0, 1, 1))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(1, 0, 1))
		st.set_uv(uv_bot_left);  st.add_vertex(pos + Vector3(0, 0, 1))

	elif normal == Vector3(0, 0, -1): # BACK
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(1, 1, 0))
		st.set_uv(uv_top_right); st.add_vertex(pos + Vector3(0, 1, 0))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(0, 0, 0))
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(1, 1, 0))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(0, 0, 0))
		st.set_uv(uv_bot_left);  st.add_vertex(pos + Vector3(1, 0, 0))

	elif normal == Vector3(1, 0, 0): # RIGHT
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(1, 1, 1))
		st.set_uv(uv_top_right); st.add_vertex(pos + Vector3(1, 1, 0))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(1, 0, 0))
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(1, 1, 1))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(1, 0, 0))
		st.set_uv(uv_bot_left);  st.add_vertex(pos + Vector3(1, 0, 1))

	elif normal == Vector3(-1, 0, 0): # LEFT
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(0, 1, 0))
		st.set_uv(uv_top_right); st.add_vertex(pos + Vector3(0, 1, 1))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(0, 0, 1))
		st.set_uv(uv_top_left);  st.add_vertex(pos + Vector3(0, 1, 0))
		st.set_uv(uv_bot_right); st.add_vertex(pos + Vector3(0, 0, 1))
		st.set_uv(uv_bot_left);  st.add_vertex(pos + Vector3(0, 0, 0))

func interact_with_block(global_hit_position: Vector3, normal: Vector3, add_block: bool):
	var local_pos = to_local(global_hit_position)
	if add_block: local_pos += (normal * 0.5)
	else: local_pos -= (normal * 0.5)
	
	var x = int(floor(local_pos.x))
	var y = int(floor(local_pos.y))
	var z = int(floor(local_pos.z))
	
	if x >= 0 and x < CHUNK_SIZE and y >= 0 and y < CHUNK_SIZE and z >= 0 and z < CHUNK_SIZE:
		if add_block: set_block(x, y, z, 1) # Default to Wood
		else: set_block(x, y, z, 0)
		update_mesh()
		if get_child_count() > 0: get_child(0).queue_free()
		create_trimesh_collision()
