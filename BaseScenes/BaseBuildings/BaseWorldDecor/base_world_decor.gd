extends RigidBody3D
class_name WorldDecor

signal interact
signal receive_damage(damage : float, direction : Vector3)

signal state_changed 

@export var health : float = 1.0


enum DECOR_STATE_TYPE {
	OPERATIONAL,
	BROKEN_DOWN
}

var decor_state : DECOR_STATE_TYPE = DECOR_STATE_TYPE.OPERATIONAL:
	set(value):
		decor_state = value
		state_changed.emit()

func is_operational() -> bool:
	return true if decor_state == DECOR_STATE_TYPE.OPERATIONAL else false

func _on_interact() -> void:
	pass # Replace with function body.

func _on_receive_damage(damage: float, direction: Vector3) -> void:
	health -= damage
	if health <= 0:
		decor_state = DECOR_STATE_TYPE.BROKEN_DOWN
	if decor_state == DECOR_STATE_TYPE.BROKEN_DOWN:
		linear_velocity -= direction * damage



func _on_state_changed() -> void:
	pass # Replace with function body.
