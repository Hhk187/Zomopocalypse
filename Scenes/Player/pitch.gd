@tool
extends Node3D

@onready var camera_pov: Camera3D = $Yaw/Camera3D/SubViewportContainerPOV/SubViewport/CameraPOV
@onready var sub_viewport_container_pov: SubViewportContainer = $Yaw/Camera3D/SubViewportContainerPOV

@onready var camera_3d: Camera3D = $Yaw/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_viewport_container_pov.set_deferred("size", DisplayServer.screen_get_size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	sub_viewport_container_pov.set_deferred("size", DisplayServer.screen_get_size())
	camera_pov.global_transform = camera_3d.global_transform 
