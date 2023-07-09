extends Node2D


var active = false

@onready var keys = [
	%Key1,
	%Key2,
	%Key3,
	%Key4,
	%Key5,
	%Key6,
]

var actions = [
	"left",
	"right",
	"back",
	"q",
	"forward",
	"e",
]

var sequence = [0,1,2,3,4,5]
var sequence_index = 0

func _ready() -> void:
	randomize()
	sequence.shuffle()
	select_key()


func select_key() -> void:
	for key in keys:
		key.visible = false
	keys[sequence[sequence_index]].visible = true


func _input(event: InputEvent) -> void:
	if not active:
		return
	
	if Input.is_action_just_pressed(actions[sequence[sequence_index]]):
		sequence_index += 1
		$AnimationPlayer.play("1")
		if sequence_index < 6:
			select_key()
		else:
			for key in keys:
				key.visible = false
			$AnimationPlayer.play("2")
			active = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "2":
		Global.select_new_patient()
		queue_free()
	elif anim_name == "0":
		active = true
