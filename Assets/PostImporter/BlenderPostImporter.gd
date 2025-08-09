@tool # Needed so it runs in editor.
extends EditorScenePostImport

# This sample changes all node names.
# Called right after the scene is imported and gets the root node.
func _post_import(scene):
	Correctify(scene)
	return scene # Remember to return the imported scene


func Correctify(node : Node3D):
	for i in node.get_children():
		if i.name.to_lower() == "m_playerscale":
			i.queue_free()
	
	for mesh : MeshInstance3D in node.find_children("*", "MeshInstance3D", true):
		var material = StandardMaterial3D.new()
		material.albedo_texture = load("res://Assets/Unsanctioned_Dreams_assets/Altlas/texture_atlas.png")
		mesh.material_override = material
	
