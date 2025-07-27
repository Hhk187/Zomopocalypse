extends BaseEntity
class_name PlayerBaseEntity


@onready var neck: Node3D = $Pitch	
@onready var right_hand: Marker3D = $Pitch/Yaw/Camera3D/RightHand
@onready var right_hand_pov: Marker3D = $Pitch/Yaw/Camera3D/SubViewportContainerPOV/SubViewport/CameraPOV/RightHandPOV

@onready var center_ray: RayCast3D = $Pitch/Yaw/Camera3D/CenterRay
