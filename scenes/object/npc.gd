extends CharacterBody2D


const SPEED = 200

@onready var tilemap: TileMap = get_parent().get_node_or_null("Ground")
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var target: Vector2 = Vector2(-325, 1525)


func _ready() -> void:
	set_physics_process(false)
	agent.set_navigation_map(tilemap)
	await get_tree().create_timer(1).timeout
	set_physics_process(true)


func _physics_process(delta: float) -> void:
#	agent.target_position = target
#	if agent.is_navigation_finished():
#		return
#	var next_path_position: Vector2 = agent.get_next_path_position()
#	var current_agent_position: Vector2 = global_position
#	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * SPEED
#	if agent.avoidance_enabled:
#		agent.set_velocity(new_velocity)
#	else:
#		_on_navigation_agent_2d_velocity_computed(new_velocity)
		
		
	agent.target_position = target
	var direction = agent.get_next_path_position() - global_position
	velocity = direction.normalized() * SPEED
	move_and_slide()


func _on_navigation_agent_2d_target_reached() -> void:
	print("done")
	pass # Replace with function body.


#func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
#	velocity = safe_velocity
#	move_and_slide()
