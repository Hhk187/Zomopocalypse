extends Resource
class_name ItemDataRes


@export var id : String
@export var name : String = "Name_Placholder"

@export_enum(
	ConstItemType.TYPE_WEAPON,
	ConstItemType.TYPE_CONUMABLE,
	ConstItemType.TYPE_TRAP
	) var item_type


@export var damage : int = 0
@export var range_unit : int = 0
@export var is_fire_auto : bool = false
## In ms
@export var fire_rate : int = 1.0


@export var ammo : int = 0
@export var max_ammo : int = 0


@export_enum(
	ConstItemType.HAND_R,
	ConstItemType.HAND_L
	) var hand
@export var offset_rotation : Vector3
@export var offset_position : Vector3



@export var is_stackable : bool
@export var max_stack : int

# ANIMATION
@export_enum(
	ConstItemType.ANIM_SHOOT,
	ConstItemType.ANIM_SWING,
	ConstItemType.ANIM_USE
	) var use_animation



var on_cooldown : bool = false
var cooldown_timer : float = 0.0
var cooldown_delta : float = 0.0

func can_be_used():
	if Time.get_ticks_msec() - cooldown_delta > fire_rate:
		if is_fire_auto:
			on_cooldown = true
			cooldown_delta = Time.get_ticks_msec()
			return true
		elif Input.is_action_just_pressed("play_fire"):
			on_cooldown = true
			cooldown_delta = Time.get_ticks_msec()
			return true
		
	else :
		on_cooldown = false
		return false
