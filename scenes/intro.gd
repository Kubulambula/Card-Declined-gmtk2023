extends Node2D


var enabled = true

var frames = [
	preload("res://assets/events/intro/intro1.png"),
	preload("res://assets/events/intro/intro2.png"),
	preload("res://assets/events/intro/intro3.png"),
	preload("res://assets/events/intro/intro4.png"),
	preload("res://assets/events/intro/intro5.png"),
	preload("res://assets/events/intro/intro6.png"),
]

var frame = 0

func _ready() -> void:
	show_next()


func show_next():
	if frame < frames.size():
		$Sprite2D.texture = frames[frame]
		frame += 1
		return
	
	if enabled:
		enabled = false
		get_parent().get_node("Left").visible = true
		get_parent().get_node("Right").visible = true
		get_parent().get_node("ColorRect").visible = true
		
		get_parent().get_node("AnimationFade").play("fade_in")
		get_parent().get_node("AnimationPlayerIntroHide").play_backwards("intro_hide")
		await get_tree().create_timer(1).timeout
		visible = false
		get_parent().get_node("AnimationPlayerIntroHide").play("intro_hide")
		await get_tree().create_timer(0.3).timeout
		get_parent().get_node("Control").visible = false
		get_parent().get_node("Control").queue_free()
		queue_free()
		get_parent().get_node("AnimationPlayerIntroHide").queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		show_next()
