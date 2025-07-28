extends Node

@export var weapons : Array[PackedScene]
var timer : int = Time.get_ticks_msec()

func _physics_process(delta: float) -> void:
	
	if Time.get_ticks_msec() % timer < 10:
		var new_weapon : BaseItem = weapons.pick_random().instantiate()
		add_child(new_weapon)
		new_weapon.global_position.y += 10
