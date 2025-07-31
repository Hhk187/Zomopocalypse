@tool # Needed so it runs in editor.
extends EditorScenePostImport

# This sample changes all node names.
# Called right after the scene is imported and gets the root node.
func _post_import(scene):
	# Change all node names to "modified_[oldnodename]"
	Rescale(scene)
	return scene # Remember to return the imported scene

func Rescale(node : Node3D):
	if node != null:
		for child in node.find_children("*", "MeshInstance3D") as Array[MeshInstance3D]:
			child.create_trimesh_collision()
			#child.get_child(0).hide()
