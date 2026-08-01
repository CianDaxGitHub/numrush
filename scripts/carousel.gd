@tool
extends Control
class_name CarouselContainer

@export var spacing: float

@export var wraparound_enabled: bool = false
@export var wraparound_radius: float
@export var wraparound_height: float

@export_range(0.0, 1.0) var opacity_strength: float
@export_range(0.0, 1.0) var scale_strength: float
@export_range(0.01, 0.99) var scale_min: float

@export var smoothing_speed: float
@export var selected_index = 0
@export var follow_button_focus: bool = false

@export var position_offset: Control = null

func _process(delta: float) -> void:
	if !position_offset or position_offset.get_child_count() == 0:
		return
	
	selected_index = clamp(selected_index, 0, position_offset.get_child_count() - 1)
	
	for i in position_offset.get_children():
		if wraparound_enabled:
			var max_index_range = max(1, position_offset.get_child_count() - 1) / 2.0
			var angle = clamp((i.get_index() - selected_index) / max_index_range, -1.0, 1.0) * PI
			var x = sin(angle) * wraparound_radius
			var y = sin(angle) * wraparound_height
			var target_pos = Vector2(x, y - wraparound_height) - i.size / 2.0
			i.position = lerp(i.position, target_pos, smoothing_speed * delta)
		else:
			var position_x = 0
			if i.get_index() > 0:
				position_x = position_offset.get_child(i.get_index() - 1).position.x + position_offset.get_child(i.get_index() - 1).size.x + spacing
			i.position = Vector2(position_x, -i.size.y / 2.0)
	
		i.pivot_offset = i.size / 2.0
		var target_scale = 1.0 - (scale_strength * abs(i.get_index() - selected_index))
		target_scale = clamp(target_scale, scale_min, 1.0)
		i.scale = lerp(i.scale, Vector2.ONE * target_scale, smoothing_speed * delta)
		
		var target_opacity = 1.0 - (opacity_strength * abs(i.get_index() - selected_index))
		target_opacity = clamp(target_opacity, 0.0, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed * delta)
		
		if i.get_index() == selected_index:
			i.z_index = 1
			i.mouse_filter = Control.MOUSE_FILTER_PASS
			for j in i.get_children():
				j.mouse_filter = Control.MOUSE_FILTER_PASS
			i.focus_mode = Control.FOCUS_NONE
		else:
			i.z_index = 0
			i.mouse_filter = Control.MOUSE_FILTER_IGNORE
			for j in i.get_children():
				j.mouse_filter = Control.MOUSE_FILTER_IGNORE
			i.focus_mode = Control.FOCUS_NONE
		
		if follow_button_focus and i.has_focus():
			selected_index = i.get_index()
	
	if wraparound_enabled:
		position_offset.position.x = lerp(position_offset.position.x, 0.0, smoothing_speed * delta)
	else:
		position_offset.position.x = lerp(position_offset.position.x, -(position_offset.get_child(selected_index).position.x + position_offset.get_child(selected_index).size.x / 2.0), smoothing_speed * delta)


func left():
	selected_index -= 1
	if selected_index < 0:
		selected_index += 1

func right():
	selected_index += 1
	if selected_index > position_offset.get_child_count() - 1:
		selected_index -= 1
