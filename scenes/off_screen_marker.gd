extends Node2D


@export var icon_texture: Texture = null
@export var marker_color: Color = Color.WHITE

@onready var icon: Sprite2D = $Marker/Icon
@onready var marker: Sprite2D = $Marker


func _ready() -> void:
	icon.texture = icon_texture


func _process(delta: float) -> void:
	var canvas = get_canvas_transform()
	var canvas_origin = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	set_marker_position(Rect2(canvas_origin, size))
	set_marker_rotation()
#	get_viewport().get_camera_2d()


func set_marker_position(bounds: Rect2) -> void:
	visible = !bounds.has_point(global_position)
	
#	visible = true
	
#	marker.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
#	marker.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)

	var target_position = get_viewport().get_camera_2d().global_position
	var displacement = global_position - target_position
	var length
	var angle
	
	var top_l = (bounds.position - target_position).angle()
	var top_r = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
	var bottom_l = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
	var bottom_r = (bounds.end - target_position).angle()
	
	if (displacement.angle() > top_l and displacement.angle() < top_r) or (displacement.angle() < bottom_l and displacement.angle() > bottom_r):
		var y_length = clamp(displacement.y, bounds.position.y - target_position.y, bounds.end.y - target_position.y)
		angle = displacement.angle() - PI / 2
		length = y_length / cos(angle) if cos(angle) != 0 else y_length
	else:
		var x_length = clamp(displacement.x, bounds.position.x - target_position.x, bounds.end.x - target_position.x)
		angle = displacement.angle()
		length = x_length / cos(angle) if cos(angle) != 0 else x_length
	
	marker.global_position.x = sin(angle) * -length
	marker.global_position.y = cos(angle) * -length
	


func set_marker_rotation() -> void:
	var angle = (global_position - marker.global_position).angle()
	marker.global_rotation = angle
	icon.global_rotation = 0
