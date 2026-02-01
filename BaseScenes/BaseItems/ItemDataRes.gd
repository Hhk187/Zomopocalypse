extends Resource
class_name ItemDataRes

enum FIRE_TYPE {
	SINGLE,
	BURST_3_SHOTS,
	FULL_AUTO
}


@export var id: int = randi()
@export var name: String = "Name_Placeholder"

@export_group("Type")
@export_enum(
	ConstItemType.TYPE_WEAPON,
	ConstItemType.TYPE_CONSUMABLE,
	ConstItemType.TYPE_GEAR,
	ConstItemType.TYPE_ITEM
	) var item_type

@export_group("Stats")
@export var damage : int = 0
@export var range_unit : int = 0
@export var firing_type : FIRE_TYPE
## In ms
@export var fire_rate : float = 1.0


@export var ammo : int = 0
@export var max_ammo : int = 0

@export_group("Sfx")
@export var sfx_fire: AudioStream

@export_group("Held")

@export var offset_rotation : Vector3
@export var offset_position : Vector3


@export_group("Inventory")
# inventory info
@export var is_stackable : bool
@export var max_stack : int
@export var tiles_width: int = 1
@export var tiles_height: int = 1
# icon creation
@export var offset_camera_size: float = 1.0
@export var offset_pos: Vector3
@export var viewport_size: Vector2i = Vector2i(512, 512)



@export_group("Animation")
# ANIMATION
@export_enum(
	ConstItemType.ANIM_SHOOT,
	ConstItemType.ANIM_SWING,
	ConstItemType.ANIM_USE
	) var use_animation


var on_cooldown : bool = false
var cooldown_timer : float = 0.0
var cooldown_delta : float = 0.0

#func can_be_used():
	#if Time.get_ticks_msec() - cooldown_delta > fire_rate:
		#match firing_type:
			#FIRE_TYPE.FULL_AUTO:
				#on_cooldown = true
				#cooldown_delta = Time.get_ticks_msec()
				#return true
			#elif Input.is_action_just_pressed("play_fire"):
				#on_cooldown = true
				#cooldown_delta = Time.get_ticks_msec()
				#return true
			#
	#else :
		#on_cooldown = false
		#return false
