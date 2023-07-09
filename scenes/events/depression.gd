extends Node2D



var actions = ["back", "left", "right", "forward", "e", "q"]
var action_index = 0
var active: bool = true
var textures = {
	"back": preload("res://assets/events/s.png"),
	"forward": preload("res://assets/events/w.png"),
	"left": preload("res://assets/events/a.png"),
	"right": preload("res://assets/events/d.png"),
	"e": preload("res://assets/events/e.png"),
	"q": preload("res://assets/events/q.png"),
}

@onready var keys = [
	%Key1,
	%Key2,
	%Key3,
]


func _ready() -> void:
	actions.shuffle()
	print(actions)
	keys[0].texture = textures[actions[0]]
	keys[1].texture = textures[actions[1]]
	keys[2].texture = textures[actions[2]]
	show_key(0)


func show_key(index: int) -> void:
	for i in keys.size():
		if index == i:
			keys[i].visible = true
		else:
			keys[i].visible = false
			

func _input(event: InputEvent) -> void:
	if not active:
		return
	
	if Input.is_action_just_pressed(actions[action_index]):
		action_index += 1
		$AnimationPlayer.play(str(action_index))
		show_key(action_index)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "3":
		print("done")
		return
