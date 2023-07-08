extends RigidBody2D

signal stopped

const CLOSED = preload("res://assets/cars/ambulance.png")
const OPENED = preload("res://assets/cars/ambulance_open.png")

@onready var tiremark1 = %TireMark1
@onready var tiremark2 = %TireMark2
@onready var smoke = %Smoke
@onready var brake_light1 = %BrakeLight1
@onready var brake_light2 = %BrakeLight2
@onready var tirescreech = %TireScreech
@onready var door = %Door
@onready var impact = %Impact

var can_drive: bool = false:
	set(value):
		if value:
			$Sprite2D.texture = CLOSED
			%Door.play()
		can_drive = value

var notify_stop: bool = false

var drift_factor: float = 0.9

var is_braking: bool = false

var turn_acceleration: float = 0.15
var slow_turn_acceleration: float = 0.1
var max_turn_speed: float = 4

var forward_acceleration: float = 1150
var max_forward_speed: float = 1700
var max_back_speed: float = 400

var last_linear_velocity: Vector2 = Vector2.ZERO

var max_speed: float = max_forward_speed
@onready var lights = $Sprite2D/AnimationPlayer

var input: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if not can_drive:
		return
	
	if not event is InputEventKey:
		return
	
	is_braking = (Input.is_action_pressed("forward") and Input.is_action_pressed("back")) or Input.is_action_pressed("brake")
	input = Vector2(Input.get_axis("left", "right"), Input.get_axis("back", "forward"))
	if input.y == -1:
		input.y = -0.5
	
	if input.y == -1 or transform.y.dot(linear_velocity.normalized()) > 0: #is going backward
		input.x = -input.x
	
	if Input.is_key_pressed(KEY_Q):
		if lights.is_playing():
			lights.play("RESET")
			$Siren.playing = false
		else:
			lights.play("flash")
			$Siren.playing = true


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_braking:
		linear_damp = 2.0 if can_drive else 3.5
		angular_damp = 1.5 if can_drive else 4.0
		input.y = 0
		drift_factor = 0.95
	else:
		linear_damp = 0.5
		angular_damp = 1
		drift_factor = 0.85
	
	apply_engine(state)
	remove_orthogonal_velocity()
	apply_steering(state)
	
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	
	tiremark1.emitting = is_drifting()
	tiremark2.emitting = is_drifting()
	smoke.emitting = is_drifting()
	brake_light1.energy = int(is_braking) * 5
	brake_light2.energy = int(is_braking) * 5
	
	if is_drifting():
		if not tirescreech.playing:
			tirescreech.play()
	else:
		if tirescreech.playing:
			tirescreech.stop()
	
	if notify_stop:
		if linear_velocity.length() < 25 and angular_velocity < 0.05:
			notify_stop = false
			stopped.emit()
			$Sprite2D.texture = OPENED
			%Door.play()
	
	last_linear_velocity = state.linear_velocity
#	print("l: ", linear_velocity.length())
#	print("a: ", angular_velocity)


func remove_orthogonal_velocity() -> void:
	var forward_velocity: Vector2 = -transform.y * -transform.y.dot(linear_velocity)
	var right_velocity: Vector2 = transform.x * transform.x.dot(linear_velocity)
	linear_velocity = forward_velocity + right_velocity * drift_factor


func is_drifting() -> bool:
	return (is_braking and linear_velocity.length() > 50) or abs(get_lateral_velocity()) > 170


func get_lateral_velocity() -> float:
	return transform.x.dot(linear_velocity)


func apply_steering(state) -> void:
	if state.linear_velocity.length() > 60 or input.y: # if moving
		state.angular_velocity += input.x * (turn_acceleration if state.linear_velocity.length() < 700 else slow_turn_acceleration)
	state.angular_velocity = clampf(state.angular_velocity, -max_turn_speed, max_turn_speed)


func apply_engine(state) -> void:
	var engine: Vector2 = -transform.y * forward_acceleration * input.y 
	state.apply_central_force(engine)


func stop_now() -> void:
	can_drive = false
	is_braking = true
	notify_stop = true


func _on_body_entered(body: Node) -> void:
	if impact.playing or body == Global.player:
		return
	if last_linear_velocity.length() > 25 or abs(angular_velocity) > 0.2:
		print("hit")
		impact.play()
