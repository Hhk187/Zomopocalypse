extends Node
class_name BaseStateManagerNode


var last_state : BaseStateRes
var current_state : BaseStateRes
var state_dict : Dictionary



func _ready() -> void:
	var path : String = "%s/States/" % owner.scene_file_path.get_base_dir()
	var dir : PackedStringArray = ResourceLoader.list_directory(path)
	if dir.is_empty():
		printerr("No states found inside %s" % path)
		return
	
	for file_name in dir:
		var script : Resource = ResourceLoader.load(path + file_name)
		var state_name : String = file_name.get_basename() # walk.gd → walk
		var state_instance : BaseStateRes = script.new(state_name as String, get_parent() as BaseEntity)
		state_dict[state_name.to_lower()] = state_instance
	
	change_state("idle")

## This function changes the current state of the playable character. [br]
## It exits the current state, sets the new state, and enters it. [br]
## @param _new_state: The name of the new state to change to. [br]
## @param args: Optional arguments to pass to the new state. [br]
## @return: None
func change_state(_new_state: String, args : Array = []):
	var new_state : BaseStateRes = state_dict[_new_state]
	# Change state only when its diffrent than the current one
	if current_state == null:
		current_state = new_state
		current_state.enter(last_state, args)
	elif current_state: 
		current_state.exit()
		last_state = current_state
		current_state = new_state
		current_state.enter(last_state, args)


func _physics_process(delta : float) -> void:
	if current_state:
		current_state.physics_process(delta)



func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)
