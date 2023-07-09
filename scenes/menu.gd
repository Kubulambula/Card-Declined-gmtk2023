extends CanvasLayer


@onready var player = $AnimationFade


func _ready() -> void:
	$Left.visible = false
	$Right.visible = false
	$ColorRect.visible = false
	_on_music_value_changed($Right/SFX.value)
	_on_sfx_value_changed($Right/Music.value)


func _on_play_pressed():
	$Left/Main/AnimationPlay.play("card")


func _on_music_value_changed(value):
	Global.set_music_volume(value)


func _on_sfx_value_changed(value):
	Global.set_sfx_volume(value)


func _on_quit_pressed() -> void:
	$Left/Main/AnimationPlay.play("card")
	if not OS.has_feature("web"):
		await get_tree().create_timer(0.7).timeout
		get_tree().quit()


func _on_animation_play_animation_finished(anim_name: StringName) -> void:
	if anim_name == "card":
		Global.hide_menu()
