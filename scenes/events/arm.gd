extends Node2D


var active: bool = false

var count = 0
var can_do_next = true

var combination: int = 0
var key_index: int = 0
var combinations = [
	["right", "left"],
	["e", "q"],
	["forward", "back"],
]

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
]

func _ready() -> void:
	randomize()
	combinations.shuffle()
	%Key1.texture = textures[combinations[combination][0]]
	%Key2.texture = textures[combinations[combination][1]]
	%Key1.visible = true


func _input(event: InputEvent) -> void:
	if not active:
		return
	if not can_do_next:
		return
	
	if Input.is_action_just_pressed(combinations[combination][key_index]):
		can_do_next = false
		count += 1
#		print("hit")
		if key_index == 0:
			$AnimationPlayer.play("1")
		else:
			$AnimationPlayer.play("2")
			pass
		keys[key_index].visible = false
		key_index = (key_index + 1) % 2
		keys[key_index].visible = true
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "3":
		Global.select_new_patient()
		queue_free()
	elif anim_name == "0":
		active = true
		can_do_next = true
	else:
		can_do_next = true
		if count == 8:
			can_do_next = false
			print("ahoj")
			keys[0].visible = false
			keys[1].visible = false
			$AnimationPlayer.play("3")
