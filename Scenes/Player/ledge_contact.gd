extends Node3D

@onready var top_ray: RayCast3D = $TopRay
@onready var bottom_ray: RayCast3D = $BottomRay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bottom_ray.is_colliding() and Input.is_action_pressed("play_forward"):
		if not top_ray.is_colliding():
			owner.global_position.y += 0.1
