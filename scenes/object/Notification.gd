extends CanvasLayer



signal done

@onready var player = %NotificationPlayer
@onready var label = %Label

var on_screen = false


var queue = []



func _ready() -> void:
	done.connect(show_text)


func add_to_queue(text: String, duration: float) -> void:
	queue.append([text, duration])
	if on_screen:
		return
	show_text()


func show_text():
	if queue.is_empty():
		hide_text()
		return
	var item = queue.pop_front()
	
	label.text = item[0]
	if not on_screen:
		on_screen = true
		player.play("show")
	else:
		player.play("new_text")
	
	await get_tree().create_timer(item[1]).timeout
	done.emit()


func hide_text() -> void:
	on_screen = false
	player.play("hide")



