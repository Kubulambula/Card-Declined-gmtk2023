extends CanvasLayer



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
