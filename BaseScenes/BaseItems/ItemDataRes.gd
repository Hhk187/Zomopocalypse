extends Resource
class_name ItemDataRes


@export var id : String
@export var name : String = "Name_Placholder"

@export_enum(
	ConstItemType.TYPE_WEAPON,
	ConstItemType.TYPE_CONUMABLE,
	ConstItemType.TYPE_TRAP
	) var item_type

@export var damage : float = 0.0
@export var range_unit : float = 0.0

@export_enum(
	ConstItemType.HAND_R,
	ConstItemType.HAND_L
	) var hand

@export var is_stackable : bool
@export var max_stack : int

# ANIMATION
@export_enum(
	ConstItemType.ANIM_SHOOT,
	ConstItemType.ANIM_SWING,
	ConstItemType.ANIM_USE
	) var use_animation
