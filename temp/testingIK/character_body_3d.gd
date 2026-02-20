@tool
extends CharacterBody3D


@onready var head_ik = $HeadIK
@onready var target = $target



func _physics_process(delta):
	head_ik.look_at(target.global_position)
