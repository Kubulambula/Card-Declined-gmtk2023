extends RigidBody2D

@onready var tiremark1 = %TireMark1
@onready var tiremark2 = %TireMark2

var max_point_count: int = 250

var drift_factor: float = .95

var is_braking: bool = false

var turn_acceleration: float = 0.3
var max_turn_speed: float = 4

var forward_acceleration: float = 1250
var back_acceleration: float = 500
var max_forward_speed: float = 1000
var max_back_speed: float = 400

var max_speed: float = max_forward_speed
@onready var lights = $Sprite2D/AnimationPlayer

var input: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	input = Vector2(Input.get_axis("left", "right"), Input.get_axis("back", "forward"))
	if input.y == -1:
		input.y = -0.4
	
	is_braking = (Input.is_action_pressed("forward") and Input.is_action_pressed("back")) or Input.is_action_pressed("brake")
	
	if Input.is_key_pressed(KEY_E):
		if lights.is_playing():
			lights.play("RESET")
		else:
			lights.play("flash")


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	apply_engine(state)
	remove_orthogonal_velocity()
	apply_steering(state)
	
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	
	tiremark1.emitting = is_drifting()
	tiremark2.emitting = is_drifting()
	
#	print(linear_velocity.length())


func remove_orthogonal_velocity() -> void:
	var forward_velocity: Vector2 = -transform.y * -transform.y.dot(linear_velocity)
	var right_velocity: Vector2 = transform.x * transform.x.dot(linear_velocity)
	linear_velocity = forward_velocity + right_velocity * drift_factor


func is_drifting() -> bool:
	return (is_braking and linear_velocity.length() > 50) or abs(get_lateral_velocity()) > 100


func get_lateral_velocity() -> float:
	return transform.x.dot(linear_velocity)


func apply_steering(state) -> void:
	if state.linear_velocity.length() > 60 or input.y: # if moving
		state.angular_velocity += input.x * turn_acceleration
	state.angular_velocity = clampf(state.angular_velocity, -max_turn_speed, max_turn_speed)


func apply_engine(state) -> void:
	var engine: Vector2 = -transform.y * forward_acceleration * input.y 
	state.apply_central_force(engine)
