extends Control


func _ready() -> void:
	_on_close_inventory()
	owner.open_inventory.connect(_on_open_inventory)
	owner.close_inventory.connect(_on_close_inventory)
	owner.toggle_inventory.connect(_on_toggle_inventory)

func _on_open_inventory(player : BaseEntity):
	get_parent().show()

func _on_close_inventory():
	get_parent().hide()


func _on_toggle_inventory(player : BaseEntity):
	if get_parent().visible:
		_on_close_inventory()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.can_look_around = true
		owner.close_inventory.emit()
	else:
		_on_open_inventory(player)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.can_look_around = false
		owner.open_inventory.emit(player)
