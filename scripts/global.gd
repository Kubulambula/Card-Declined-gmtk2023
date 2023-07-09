extends Node



var depressed_lines = [
	"That girl’s overdue on her therapy payments!",
	"I diagnosed her as broke with past due payments. Get me my money!",
	"That depression therapy wasn't for free!",
	"Low self-esteem? She should have mentioned the low credit score!"
]

var arm_lines = [
	"This guy’s prosthetic payments are past due! Get me that thing back.",
	"That guy scammed us out of a prosthetic! Get him!",
	"Well that arm would have come in handy if he had paid for it.",
]

var hair_lines = [
	"Did you know, that barbers used to be doctors? Now do your reversed role stuff.",
	"We gave this guy a haircut and he gave us fake money! Revenge us!",
	"He went for a haircut with an empty wallet. Run after him!",
]


var depression = preload("res://scenes/events/depression.tscn")
var arm = preload("res://scenes/events/arm.tscn")
var hair = preload("res://scenes/events/hair.tscn")


const npc = preload("res://scenes/object/npc.tscn")
var patient_marker = preload("res://scenes/object/off_screen_marker.tscn").instantiate()



var menu_visible = true

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
var menu = preload("res://scenes/menu.tscn").instantiate()


func _ready() -> void:
	get_tree().paused = true
	patient_marker.icon_texture = preload("res://assets/player/pointer_patient.png")
	process_mode = Node.PROCESS_MODE_ALWAYS
	event_canvas.layer = 99
	add_child(event_canvas)
	add_child(menu)
	player.can_move = false
	


func select_new_patient() -> void:
	player.can_move = true
	if player.e:
		player.e.visible = false
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
	
	await get_tree().create_timer(2.5).timeout
	match event_type:
		EventType.DEPRESSION:
			player.notification_node.add_to_queue(depressed_lines.pick_random(), 7)
		EventType.ARM:
			player.notification_node.add_to_queue(arm_lines.pick_random(), 7)
		EventType.HAIR:
			player.notification_node.add_to_queue(hair_lines.pick_random(), 7)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		print("esc pls")
		if menu_visible:
			hide_menu()
		else:
			show_menu()


func show_menu():
	menu.visible = true
	menu_visible = true
	menu.player.play("fade_in")
	get_tree().paused = true


func hide_menu():
	menu_visible = false
	menu.player.play_backwards("fade_in")
	get_tree().paused = false
	await get_tree().create_timer(0.3).timeout
	menu.visible = false



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
	player.can_move = false
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
