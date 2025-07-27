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


func movements():
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and entity.is_on_floor():
		entity.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (entity.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		entity.velocity.x = direction.x * SPEED
		entity.velocity.z = direction.z * SPEED
	else:
		entity.velocity.x = move_toward(entity.velocity.x, 0, SPEED)
		entity.velocity.z = move_toward(entity.velocity.z, 0, SPEED)

	entity.move_and_slide()

	
func gravity(delta):
	entity.velocity += entity.get_gravity() * delta
