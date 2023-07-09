extends CharacterBody2D


var max_speed = 400.0
var turn_speed = 10
var acceleration = 4000
var friction = 2500

var can_get_in_car: bool = false
var inside_car: bool = false

var can_patient: bool = false


@onready var notification_node = %Notification

var can_move: bool = true

@onready var patient_area_shape = %PatientAreaShape
@onready var world = get_parent()
@onready var e = %E

func _init() -> void:
	Global.player = self

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	notification_node.add_to_queue("Get in the car and teach them a lesson. If you can't pay, don't go to the doctor!", 10)


func _physics_process(delta: float) -> void:
#	look_at(get_global_mouse_position())
	
	if inside_car or not can_move:
		return
	
	var direction := Input.get_vector("left", "right", "forward", "back")
	rotation = lerp_angle(rotation, direction.angle(), delta * turn_speed)
	if direction:
		$AnimationPlayer.play("walking")
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(max_speed)
	else:
		$AnimationPlayer.play("RESET")
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if not can_move:
		return
	if can_patient and Input.is_action_just_pressed("e"):
		can_patient = false
		Global.do_event()
	
	elif can_get_in_car and Input.is_action_just_pressed("e"):
		if inside_car:
			get_out()
		else:
			get_in()


func get_in() -> void:
	$CollisionShape2D.disabled = true
	var area = $CarDoorArea.get_overlapping_areas()[0]
	world.call_deferred("remove_child", self)
	area.call_deferred("add_child", self)
	position = Vector2.ZERO
	
	inside_car = true
	patient_area_shape.set_deferred("disabled", true)
	visible = false
#	await get_tree().create_timer(0.2).timeout
	area.get_parent().can_drive = true


func get_out() -> void:
	var area = $CarDoorArea.get_overlapping_areas()[0]
	var car = area.get_parent()
	car.stop_now()
	await car.stopped
	
	$Camera2D.position_smoothing_enabled = false
	
	area.call_deferred("remove_child", self)
	world.call_deferred("add_child", self)
	set_deferred("global_position", area.get_node("GetOutPosition").global_position)
	
	inside_car = false
	patient_area_shape.set_deferred("disabled", false)
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	
	await get_tree().create_timer(0.1).timeout
	$Camera2D.position_smoothing_enabled = true
	


func _on_car_door_area_area_entered(area: Area2D) -> void:
	can_get_in_car = true
	e.visible = true

func _on_car_door_area_area_exited(area: Area2D) -> void:
	can_get_in_car = false
	e.visible = false


func _on_patient_area_body_entered(body: Node2D) -> void:
	if not body == Global.patient:
		return
	can_patient = true
	e.visible = true


func _on_patient_area_body_exited(body: Node2D) -> void:
	if not body == Global.patient:
		return
	can_patient = false
	e.visible = false


func _process(delta: float) -> void:
	e.global_rotation = 0
	e.global_position = global_position + Vector2(0, -90)
