extends Node

@export var weapons : Array[PackedScene]

func _ready() -> void:
	
	for i in range(weapons.size()):
		var new_w : BaseItem = weapons[i].instantiate()
		add_child(new_w)
		new_w.global_position = Vector3(i * 0.5,1,0)
