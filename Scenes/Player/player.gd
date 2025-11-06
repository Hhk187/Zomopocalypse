@tool
extends BaseEntity
class_name PlayerBaseEntity

const THIRD_PERSON_POS = Vector3(0.64, 0.135, 1.153)

@onready var animation_player: AnimationPlayer = $Model/BaseCharacter/AnimationPlayer

@onready var camera_3d: CameraPlayer = $Pitch/Yaw/CameraSpringArm3D/Camera3D
@onready var camera_spring_arm_3d: SpringArm3D = $Pitch/Yaw/CameraSpringArm3D

@onready var pitch: Node3D = $Pitch
@onready var yaw: Node3D = $Pitch/Yaw


var equiped_weapon : BaseItem
@onready var interaction_area: InteractionArea = $InteractionArea


@onready var animation_tree = $AnimationTree

@export var is_third_person: bool = false :
	set(value):
		# fix bug where camera_spring_arm_3d is null
		if not camera_spring_arm_3d: return
		
		is_third_person = value
		if not is_third_person:
			camera_spring_arm_3d.position = Vector3.ZERO
		else:
			camera_spring_arm_3d.position = THIRD_PERSON_POS


func toggle_pov() -> void:
	is_third_person = !is_third_person



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("play_toggle_pov"):
		toggle_pov()
	
	elif event.is_action_pressed('play_inspect'):
		pass
	
	elif event.is_action_pressed("play_pickup"):
		interaction_area.pick_up_item()
		animation_tree.set("parameters/OneShot/request", 1)
	elif event.is_action_pressed("player_emote_1"):
		if animation_tree.get("parameters/OneShot2/active"):
			animation_tree.set("parameters/OneShot2/request", 2)
		else:
			animation_tree.set("parameters/OneShot2/request", 1)

	elif event.is_action_pressed("play_fire"):
		test_use_weapon()


func test_use_weapon():
	# Getting viewport res
	var viewport = Vector2(
		ProjectSettings.get("display/window/size/viewport_width"),
		ProjectSettings.get("display/window/size/viewport_height")
		)

	# Setting position in space
	var ray_origin = camera_3d.project_ray_origin(viewport * 0.5)
	#ray_origin = Vector3(ray_origin.x, ray_origin.y, 0)
	var ray_end  = ray_origin + camera_3d.project_ray_normal(viewport * 0.5) * 50
	
	# Creating raycast
	var new_interserction = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	new_interserction.collide_with_bodies = true

	# Getting collider
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_interserction)

	if not intersection.is_empty():
		
		var col_point = intersection.position
		var collider = intersection.collider
		
		#if collider is RigidBody3D:
			#if collider.get_collision_layer_value(3): 
				#collider = collider as WorldDecor
				#collider.receive_damage.emit(equiped_weapon.item_data.damage, global_basis.z)
			#else :
				#collider.linear_velocity -= global_basis.z * equiped_weapon.item_data.damage
		var new_mesh := MeshInstance3D.new()
		new_mesh.mesh = SphereMesh.new()
		new_mesh.scale = Vector3(0.2,0.2,0.2)
		collider.add_child(new_mesh)
		new_mesh.global_position = col_point

	#print(ray_origin, ray_origin)






#func use_weapon():
	#if equiped_weapon.item_data.can_be_used() : 
		#var viewport = DisplayServer.screen_get_size()
		#
		#var ray_origin  = camera_3d.project_ray_origin(viewport * 0.5)
		#var ray_end  = ray_origin + camera_3d.project_ray_normal(viewport * 0.5) * equiped_weapon.item_data.range_unit
		#
		#var new_interserction = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		#new_interserction.collide_with_areas = true
		#new_interserction.collide_with_bodies = true
		#new_interserction.collision_mask = pow(2, 1-1) + pow(2, 2-1) + pow(2, 3-1) + pow(2, 4-1)
		#var intersection = get_world_3d().direct_space_state.intersect_ray(new_interserction)
		#
		#if not intersection.is_empty():
			#var col_point = intersection.position
			#var collider = intersection.collider
			#
			#if collider is RigidBody3D:
				#if collider.get_collision_layer_value(3): 
					#collider = collider as WorldDecor
					#collider.receive_damage.emit(equiped_weapon.item_data.damage, global_basis.z)
				#else :
					#collider.linear_velocity -= global_basis.z * equiped_weapon.item_data.damage
			#var new_mesh := MeshInstance3D.new()
			#new_mesh.mesh = SphereMesh.new()
			#new_mesh.scale = Vector3(0.2,0.2,0.2)
			#collider.add_child(new_mesh)
			#new_mesh.global_position = col_point
		#
		#right_hand_pov.animation_player.stop()
		#right_hand_pov.animation_player.play("shoot")
		#var audio = AudioStreamPlayer3D.new()
		#audio.stream = preload("res://Assets/SFX/Weapons/Rifle/AK_Shot.wav")
		#add_child(audio)
		##audio.volume_db = -10
#
		#audio.play()
	
	
	#var object : Node3D = combat_ray.get_collider()
	#if object:
		#var point = combat_ray.get_collision_point()
		#var normal = combat_ray.get_collision_normal()
		#var new_mesh := MeshInstance3D.new()
		#new_mesh.mesh = SphereMesh.new()
		#object.add_child(new_mesh)
		#new_mesh.global_position = point
