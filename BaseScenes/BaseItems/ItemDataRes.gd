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
@export var is_fire_auto : bool = false
@export var fire_rate : float = 1.0


@export var ammo : float = 0.0
@export var max_ammo : float = 0.0


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



var on_cooldown : bool = false
var cooldown_timer : float = 0.0
var cooldown_delta : float = 0.0

func can_be_used():
	if not on_cooldown and not is_fire_auto:
		if Input.is_action_just_pressed("play_fire"):
			on_cooldown = true
			cooldown_delta = Time.get_ticks_msec()
			return true
	
	if Time.get_ticks_msec() - cooldown_delta > fire_rate:
		on_cooldown = true
		cooldown_delta = Time.get_ticks_msec()
		return true
	else :
		on_cooldown = false
		return false
