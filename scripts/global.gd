extends Node


var depression = preload("res://scenes/events/depression.tscn")
var arm = preload("res://scenes/events/arm.tscn")
var hair = preload("res://scenes/events/hair.tscn")


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

enum EventType {
	DEPRESSION,
	ARM,
	HAIR,
}

var event_type: EventType = EventType.DEPRESSION


var event_canvas = CanvasLayer.new()


func _ready() -> void:
	event_canvas.layer = 99
	add_child(event_canvas)


func select_new_patient() -> void:
	patient_marker.visible_override = 0
	player.can_patient = false
	if patient:
		patient.walk_speed = 400
	var new_patient = npc_list.pick_random()
	while new_patient == patient:
		new_patient = npc_list.pick_random()
	patient = new_patient
	if patient_marker.get_parent():
		patient_marker.get_parent().remove_child(patient_marker)
	patient_marker.hide_on_screen = false
	patient.add_child(patient_marker)
	patient_marker.position = Vector2.ZERO
	randomize()
	event_type = randi() % 3


func get_random_poi() -> Vector2:
	poi_index += 1
	return poi_list[poi_index % poi_list.size()]



func set_master_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func set_music_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func set_sfx_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func do_event() -> void:
	patient_marker.visible_override = 2
	var scene
	match event_type:
		EventType.DEPRESSION:
			scene = depression.instantiate()
		EventType.ARM:
			scene = arm.instantiate()
		EventType.HAIR:
			scene = hair.instantiate()
	patient.walk_speed = 0
	event_canvas.add_child(scene)
