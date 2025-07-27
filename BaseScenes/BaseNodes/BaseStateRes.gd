extends Resource
class_name BaseStateRes



var entity : BaseEntity
var state_manager_node : BaseStateManagerNode
var name : String


func _init(_name : String, _entity : BaseEntity) -> void:
	name = _name
	entity = _entity

func enter(_last_state : BaseStateRes = null, _args : Array = []):
	pass

func exit():
	pass

func physics_process(_delta : float) -> void:
	pass

func input(_event : InputEvent):
	pass

func change_state(state : String):
	state_manager_node.change_state(state)
