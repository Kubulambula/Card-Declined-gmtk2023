extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	$Left/Main/AnimationPlay.play("card")


func _on_music_value_changed(value):
	Global.set_music_volume(value)


func _on_sfx_value_changed(value):
	Global.set_sfx_volume(value)
