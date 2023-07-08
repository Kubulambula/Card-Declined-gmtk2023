extends Node

var player: Node = null
var poi_list: Array[Vector2] = [Vector2(-4000, 1400)]: # big empty place
	set(value):
		randomize()
		value.shuffle()
		poi_list = value

var poi_index: int = 0

func get_random_poi() -> Vector2:
	poi_index += 1
	return poi_list[poi_index % poi_list.size()]
