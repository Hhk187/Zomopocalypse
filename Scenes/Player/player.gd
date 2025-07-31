extends BaseEntity
class_name PlayerBaseEntity


@onready var neck: Node3D = $Pitch
@onready var right_hand: Marker3D = $Pitch/Yaw/Camera3D/RightHand
@onready var camera_3d: CameraPlayer = $Pitch/Yaw/Camera3D

@onready var right_hand_pov: Marker3D = $Pitch/Yaw/Camera3D/SubViewportContainerPOV/SubViewport/CameraPOV/RightHandPOV

@onready var interaction_ray: RayCast3D = $Pitch/Yaw/Camera3D/InteractionRay

@onready var sub_viewport: SubViewport = $Pitch/Yaw/Camera3D/SubViewportContainerPOV/SubViewport

var equiped_weapon : BaseItem


func use_weapon():
	if equiped_weapon.item_data.can_be_used() : 
		var viewport = get_viewport().size
		
		var ray_origin  = camera_3d.project_ray_origin(viewport * 0.5)
		var ray_end  = ray_origin + camera_3d.project_ray_normal(viewport * 0.5) * equiped_weapon.item_data.range_unit
		
		var new_interserction = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		new_interserction.collide_with_areas = true
		new_interserction.collide_with_bodies = true
		new_interserction.collision_mask = pow(2, 1-1) + pow(2, 2-1) + pow(2, 3-1) + pow(2, 4-1)
		var intersection = get_world_3d().direct_space_state.intersect_ray(new_interserction)
		
		if not intersection.is_empty():
			var col_point = intersection.position
			var collider = intersection.collider
			
			if collider is RigidBody3D:
				if collider.get_collision_layer_value(3): 
					collider = collider as WorldDecor
					collider.receive_damage.emit(equiped_weapon.item_data.damage, global_basis.z)
				else :
					collider.linear_velocity -= global_basis.z * equiped_weapon.item_data.damage
			var new_mesh := MeshInstance3D.new()
			new_mesh.mesh = SphereMesh.new()
			new_mesh.scale = Vector3(0.2,0.2,0.2)
			collider.add_child(new_mesh)
			new_mesh.global_position = col_point
		
		right_hand_pov.animation_player.stop()
		right_hand_pov.animation_player.play("shoot")
	
	
	#var object : Node3D = combat_ray.get_collider()
	#if object:
		#var point = combat_ray.get_collision_point()
		#var normal = combat_ray.get_collision_normal()
		#var new_mesh := MeshInstance3D.new()
		#new_mesh.mesh = SphereMesh.new()
		#object.add_child(new_mesh)
		#new_mesh.global_position = point
