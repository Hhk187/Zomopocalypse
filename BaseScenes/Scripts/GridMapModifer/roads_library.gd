@tool
extends Node3D


@export var scale_mod : int = 8
@export var run : bool : 
	set(value):
		_run()

func _run() -> void:
	var meshs = find_children("*", "MeshInstance3D") as Array[MeshInstance3D]
	
	for mesh : MeshInstance3D in meshs:
		mesh.scale = Vector3.ONE * scale_mod
		mesh.set_owner(self)
