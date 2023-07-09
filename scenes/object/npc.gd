extends CharacterBody2D


var bodies = [
	preload("res://assets/player/npc_body1.png"),
	preload("res://assets/player/npc_body2.png"),
	preload("res://assets/player/npc_body3.png"),
	preload("res://assets/player/npc_body4.png"),
	preload("res://assets/player/npc_body5.png"),
]
var heads = [
	preload("res://assets/player/npc_head1.png"),
	preload("res://assets/player/npc_head2.png"),
	preload("res://assets/player/npc_head3.png"),
	preload("res://assets/player/npc_head4.png"),
	preload("res://assets/player/npc_head5.png"),
]



var walk_speed: float = 200
var turn_speed: float = 8

@onready var tilemap: TileMap = get_parent().get_node_or_null("Ground")
@onready var agent: NavigationAgent2D = $NavigationAgent2D

var initial_target: Vector2


func _init() -> void:
#	Global.npc_list.append(self)
	global_position = Global.get_random_poi()

func _ready() -> void:
	agent.set_navigation_map(tilemap)
	agent.max_speed = walk_speed
	set_target(initial_target)
	set_physics_process(false)
	await get_tree().create_timer(0.25).timeout
	set_physics_process(true)
	
	randomize_apperance()


func set_target(target_position: Vector2) -> void:
	agent.target_position = target_position


func _physics_process(delta: float) -> void:
#	if (global_position - Global.player.global_position).length() > 2000:
#		return
#	set_target(get_global_mouse_position())
	if agent.distance_to_target() > 100:
		var next_path_position: Vector2 = agent.get_next_path_position()
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * walk_speed
		rotation = lerp_angle(rotation, new_velocity.angle(), delta * turn_speed)
		if agent.avoidance_enabled:
			agent.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)
		
#		var direction = agent.get_next_path_position() - global_position
#		velocity = direction.normalized() * walk_speed
#		move_and_slide()
	else:
		set_target(Global.get_random_poi())


func _on_navigation_agent_2d_target_reached() -> void:
	set_target(Global.get_random_poi())


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func randomize_apperance():
	randomize()
	$Node2D/Body.texture = bodies.pick_random()
	$Node2D/Head.texture = heads.pick_random()
	bodies = []
	heads = []
