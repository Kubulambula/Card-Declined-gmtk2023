extends CharacterBody2D


var max_speed = 400.0
var acceleration = 2000
var friction = 2500


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "forward", "back")
	if direction:
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(max_speed)
	else:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO
	
	look_at(get_global_mouse_position())
	
	move_and_slide()
	print(velocity)
