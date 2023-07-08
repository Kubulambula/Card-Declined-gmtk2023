extends CharacterBody2D


var max_speed = 400.0
var acceleration = 4000
var friction = 2500

var can_get_in_car: bool = false
var inside_car: bool = false

@onready var world = get_parent()

func _init() -> void:
	Global.player = self


func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if inside_car:
		return
	
	var direction := Input.get_vector("left", "right", "forward", "back")
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
	if can_get_in_car and Input.is_action_just_pressed("e"):
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
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	
	await get_tree().create_timer(0.1).timeout
	$Camera2D.position_smoothing_enabled = true
	


func _on_car_door_area_area_entered(area: Area2D) -> void:
	can_get_in_car = true


func _on_car_door_area_area_exited(area: Area2D) -> void:
	can_get_in_car = false
