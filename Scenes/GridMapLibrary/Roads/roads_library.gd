@tool
extends Node3D


@export var create_collision : bool : 
	set(value):
		set_create_collision()


func set_create_collision():
	var collisions = find_children("*", "StaticBody3D") as Array[StaticBody3D]
	if collisions:
		for col in collisions:
			col.queue_free()
	
	var meshs = find_children("*", "MeshInstance3D") as Array[MeshInstance3D]
	
	for mesh : MeshInstance3D in meshs:
		mesh.create_convex_collision(true, true)
		mesh.set_owner(self)
