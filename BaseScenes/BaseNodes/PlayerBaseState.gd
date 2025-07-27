extends BaseStateRes
class_name PlayerBaseState


static var can_look_around : bool = true
const JUMP_VELOCITY = 4.5
const SPEED = 5.0


func input(event : InputEvent):
	if not can_look_around: return
	var player = entity as PlayerBaseEntity
	if event is InputEventMouseMotion:
		player.rotate_y(-(event.relative.x * 0.004))
		player.neck.rotate_x(-(event.relative.y * 0.004))
		player.neck.rotation_degrees.x = clamp(player.neck.rotation_degrees.x,-90.0, 90.0)

		CameraPOV.sway2D(event.relative)



func movements(delta):
	# Handle jump.
	if Input.is_action_just_pressed("play_jump") and entity.is_on_floor():
		entity.velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("play_left", "play_right", "play_forward", "play_backward")
	var direction := (entity.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		entity.velocity.x = lerp(entity.velocity.x, direction.x * SPEED, 0.2)
		entity.velocity.z = lerp(entity.velocity.z, direction.z * SPEED, 0.2)
	else:
		entity.velocity.x = lerp(entity.velocity.x, 0.0, 0.3)
		entity.velocity.z = lerp(entity.velocity.z, 0.0, 0.3)

	entity.move_and_slide()

func just_fall(delta):
	entity.velocity += entity.get_gravity() * delta

func gravity(delta):
	if not entity.is_on_floor():
		change_state("falling")


func interaction():
	if entity.center_ray.is_colliding():
		if Input.is_action_just_pressed("play_pickup") and not entity.right_hand.get_child_count():
			var weapon = entity.center_ray.get_collider()
			weapon.equipe()
			weapon.get_parent().remove_child(weapon)
			entity.right_hand.add_child(weapon)
	if Input.is_action_just_pressed("play_drop") and entity.right_hand.get_child_count():
		entity.right_hand.get_child(0).un_equipe()
