extends Node

var player: Node = null
var poi_list: Array[Vector2] = [Vector2(-4000, 1400)]: # big empty place
	set(value):
		randomize()
		value.shuffle()
		poi_list = value

var npc_list: Array[Node] = []
var music_player: AudioStreamPlayer = null

var poi_index: int = 0


func get_random_poi() -> Vector2:
	poi_index += 1
	return poi_list[poi_index % poi_list.size()]


func set_music_volume(value: int) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func set_sfx_volume(value: int) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
