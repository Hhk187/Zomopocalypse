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
	if health <= 0 and decor_state != DECOR_STATE_TYPE.BROKEN_DOWN:
		decor_state = DECOR_STATE_TYPE.BROKEN_DOWN
		linear_velocity -= direction * damage * 0.6
		angular_velocity -= direction * damage 
		_play_sound_breaking()
	if decor_state == DECOR_STATE_TYPE.BROKEN_DOWN:
		linear_velocity -= direction * damage * 0.1


func _play_sound(_audio : AudioStream):
	var audio = AudioStreamPlayer3D.new()
	audio.stream = _audio
	audio.finished.connect(audio.queue_free)
	add_child(audio)
	audio.call_deferred("play")

func _play_sound_breaking():
	_play_sound(load("res://Assets/SFX/WorldDecor/Break/Break.wav"))

func _on_state_changed() -> void:
	if decor_state == DECOR_STATE_TYPE.BROKEN_DOWN:
		_play_sound_breaking()
		set_collision_layer_value(1, false)
		sleeping = false
		freeze = false
