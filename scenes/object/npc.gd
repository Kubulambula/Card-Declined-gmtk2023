extends CharacterBody2D


var walk_speed: float = 200
var turn_speed: float = 8

@onready var tilemap: TileMap = get_parent().get_node_or_null("Ground")
@onready var agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	global_position = Global.get_random_poi()
	set_target(Global.get_random_poi())
	set_physics_process(false)
	agent.set_navigation_map(tilemap)
	await get_tree().create_timer(1).timeout
	set_physics_process(true)


func set_target(target_position: Vector2) -> void:
	agent.target_position = target_position


func _physics_process(delta: float) -> void:
	set_target(get_global_mouse_position())
	if agent.distance_to_target() > 100:
		var direction = agent.get_next_path_position() - global_position
		rotation = lerp_angle(rotation, direction.angle(), delta * turn_speed)
		velocity = direction.normalized() * walk_speed
		move_and_slide()
	else:
		set_target(Global.get_random_poi())


func _on_navigation_agent_2d_target_reached() -> void:
	print("done")
