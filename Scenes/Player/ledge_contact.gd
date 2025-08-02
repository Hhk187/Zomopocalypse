extends Node3D

@onready var top_ray: RayCast3D = $TopRay
@onready var floor_ray: RayCast3D = $TopRay/FloorRay
@onready var bottom_ray: RayCast3D = $BottomRay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (bottom_ray.is_colliding() and 
		Input.is_action_pressed("play_forward") and 
		owner.is_on_floor() and
		bottom_ray.get_collision_normal().y == 0 and 
		not top_ray.is_colliding()
		):
			owner.global_position.y += abs(owner.global_position.y - floor_ray.get_collision_point().y)
