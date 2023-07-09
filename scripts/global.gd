extends Node


const npc = preload("res://scenes/object/npc.tscn")
var patient_marker = preload("res://scenes/object/off_screen_marker.tscn").instantiate()

var map
var player: Node = null
var poi_list: Array[Vector2] = [Vector2(-4000, 1400)]: # big empty place
	set(value):
		poi_list = value
		
		for poi in poi_list:
			var n = npc.instantiate()
			map.add_child.call_deferred(n)
			n.global_position = poi
			npc_list.append(n)
		
		randomize()
		poi_list.shuffle()
		for i in npc_list.size():
			npc_list[i].initial_target = poi_list[i % poi_list.size()]
		randomize()
		select_new_patient()

var npc_list: Array[Node] = []
var music_player: AudioStreamPlayer = null

var poi_index: int = 0

var patient = null


func select_new_patient() -> void:
	var new_patient = npc_list.pick_random()
	while new_patient == patient:
		new_patient = npc_list.pick_random()
	patient = new_patient
	if patient_marker.get_parent():
		patient_marker.get_parent().remove_child(patient_marker)
	patient.add_child(patient_marker)
	patient_marker.position = Vector2.ZERO


func get_random_poi() -> Vector2:
	poi_index += 1
	return poi_list[poi_index % poi_list.size()]


func set_music_volume(value: int) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func set_sfx_volume(value: int) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
