extends RigidBody2D


var drift_factor: float = 0.8

var is_braking: bool = false

var turn_acceleration: float = 0.3
var max_turn_speed: float = 3

var forward_acceleration: float = 800
var back_acceleration: float = 500
var max_forward_speed: float = 300
var max_back_speed: float = 200

var max_speed: float = max_forward_speed


var input: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	input = Vector2(Input.get_axis("left", "right"), Input.get_axis("back", "forward"))
	if input.y == -1:
		input.y = -0.25
	
	is_braking = (Input.is_action_pressed("forward") and Input.is_action_pressed("back")) or Input.is_action_pressed("brake")


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	apply_engine(state)
	remove_orthogonal_velocity()
	apply_steering(state)
	
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	
	print(is_drifting())


func remove_orthogonal_velocity() -> void:
	var forward_velocity: Vector2 = -transform.y * -transform.y.dot(linear_velocity)
	var right_velocity: Vector2 = transform.x * transform.x.dot(linear_velocity)
	linear_velocity = forward_velocity + right_velocity * drift_factor


func is_drifting() -> bool:
	return (is_braking and linear_velocity.length() > 50) or abs(get_lateral_velocity()) > 100


func get_lateral_velocity() -> float:
	return transform.x.dot(linear_velocity)


func apply_steering(state) -> void:
	if state.linear_velocity.length() > 50 : # if moving
		state.angular_velocity += input.x * turn_acceleration
	state.angular_velocity = clampf(state.angular_velocity, -max_turn_speed, max_turn_speed)


func apply_engine(state) -> void:
	var engine: Vector2 = -transform.y * forward_acceleration * input.y 
	state.apply_central_force(engine)
