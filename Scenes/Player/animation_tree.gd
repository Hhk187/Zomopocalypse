@tool
extends AnimationTree






@export var set_filter_LH: bool:
	set(value):
		set_filter_LH = value
		var root: AnimationNodeBlendTree = tree_root
		var one_shot: AnimationNodeOneShot = root.get_node("OneShotUpperBody")
		
		for path in AnimationsBlendFilters.LEFT_HAND:
			one_shot.set_filter_path(path, set_filter_LH)

@export var set_filter_RH: bool:
	set(value):
		set_filter_RH = value
		var root: AnimationNodeBlendTree = tree_root
		var one_shot: AnimationNodeOneShot = root.get_node("OneShotUpperBody")
		
		for path in AnimationsBlendFilters.RIGHT_HAND:
			one_shot.set_filter_path(path, set_filter_RH)
