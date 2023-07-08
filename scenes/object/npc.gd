extends CharacterBody2D


const SPEED = 200

@onready var tilemap: TileMap = get_parent().get_node_or_null("Ground")
@onready var agent: NavigationAgent2D = $NavigationAgent2D
#@onready var target: Vector2 = Vector2(-325, 1525)


func _ready() -> void:
	set_target(Vector2(-325, 1525))
	set_physics_process(false)
	agent.set_navigation_map(tilemap)
	await get_tree().create_timer(1).timeout
	set_physics_process(true)


func set_target(target_position: Vector2) -> void:
	agent.target_position = target_position


func _physics_process(delta: float) -> void:
	set_target(get_global_mouse_position())
	var direction = agent.get_next_path_position() - global_position
	velocity = direction.normalized() * SPEED
	move_and_slide()


func _on_navigation_agent_2d_target_reached() -> void:
	print("done")
	pass # Replace with function body.


#func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
#	velocity = safe_velocity
#	move_and_slide()
