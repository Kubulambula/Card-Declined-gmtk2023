extends Node2D


var poi_list: Array[Vector2] = []

func _ready() -> void:
	Global.map = get_parent()
	
	for child in get_children():
		poi_list.append(child.global_position)
	Global.poi_list = poi_list
	queue_free()
