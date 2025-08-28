@tool
extends Node3D

var arrow : Node3D

@export var toggle_building_direction : bool = false :
	set(value):
		toggle_building_direction = value
		on_toggle_building_direction(toggle_building_direction)

func _ready() -> void:
	_create_arrow()
	
	for block : CSGBox3D in get_children():
		var arrow_dup : Node3D = arrow.duplicate()
		arrow_dup.position.z -= block.size.z * 0.5 + 1
		block.add_child(arrow_dup)

func _create_arrow():
	# the arrow it self
	arrow = Node3D.new()
	arrow.rotation_degrees.x = 90
	# base of the arrow
	var cylinder := MeshInstance3D.new()
	var cylinder_mesh := CylinderMesh.new()
	cylinder.mesh = cylinder_mesh
	cylinder_mesh.bottom_radius = 0.3
	cylinder_mesh.top_radius = 0.3
	# tip of the arrow
	var tip := MeshInstance3D.new()
	tip.position.y = -1.5
	var tip_mesh = CylinderMesh.new()
	tip.mesh = tip_mesh
	tip_mesh.bottom_radius = 0.0
	tip_mesh.height = 1
	# adding them to the arrow it self
	arrow.add_child(cylinder)
	arrow.add_child(tip)
	arrow.hide()


func on_toggle_building_direction(value):
	for i : CSGBox3D in get_children():
		i.get_child(0).visible = value
