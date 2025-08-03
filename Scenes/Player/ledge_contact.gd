extends Node3D

@onready var top_ray: RayCast3D = $TopRay
@onready var floor_ray: RayCast3D = $TopRay/FloorRay
@onready var bottom_ray: RayCast3D = $BottomRay
var input_dir
var cal
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("play_right", "play_left", "play_backward", "play_forward")
	
	cal =  asin(input_dir.x)# + asin(input_dir.x)
	rotation.y = cal
	
	if (bottom_ray.is_colliding() and 
		input_dir and 
		owner.is_on_floor() and
		(bottom_ray.get_collision_normal().y == 0 or floor_ray.get_collision_normal().y == 1) and
		not top_ray.is_colliding()
		):
			owner.global_position.y += abs(owner.global_position.y - floor_ray.get_collision_point().y)
