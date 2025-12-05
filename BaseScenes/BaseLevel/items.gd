extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in get_children() as Array[Node3D]:
		if i.global_position.y < -1000:
			i.global_position = Vector3(i.global_position.x, 10, i.global_position.z)
