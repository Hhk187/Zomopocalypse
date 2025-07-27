extends Node3D

@onready var camera_3d: Camera3D = $Yaw/Camera3D
@onready var camera_pov: Camera3D = $Yaw/Camera3D/SubViewportContainer/SubViewport/CameraPOV


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	camera_pov.global_transform = camera_3d.global_transform
