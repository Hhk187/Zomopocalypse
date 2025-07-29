@tool # Needed so it runs in editor.
extends EditorScenePostImport

var scale = 10

# This sample changes all node names.
# Called right after the scene is imported and gets the root node.
func _post_import(scene):
	# Change all node names to "modified_[oldnodename]"
	Rescale(scene)
	return scene # Remember to return the imported scene

func Rescale(node : Node3D):
	if node != null:
		node.name = "modified_" + node.name
		for child in node.find_children("*", "MeshInstance3D") as Array[MeshInstance3D]:
			child.scale = Vector3.ONE * scale
			child.create_convex_collision()
