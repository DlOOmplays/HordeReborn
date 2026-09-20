class_name SelectionController
extends Node2D

const SELECTABLE_GROUP := &"selectable_units"

@export var drag_threshold := 10.0
@export var command_controller_path: NodePath

var _selected_units: Array[PlaceholderUnit] = []
var _drag_start := Vector2.ZERO
var _drag_current := Vector2.ZERO
var _tracking_left_click := false
var _is_dragging := false
var _additive_selection := false

@onready var _command_controller: MoveCommandController = get_node_or_null(command_controller_path) as MoveCommandController

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion and _tracking_left_click:
		_drag_current = get_global_mouse_position()
		if _drag_current.distance_to(_drag_start) >= drag_threshold:
			_is_dragging = true
		queue_redraw()

func _draw() -> void:
	if not _is_dragging:
		return
	var selection_rect := Rect2(_drag_start, _drag_current - _drag_start).abs()
	draw_rect(selection_rect, Color(0.42, 0.85, 1.0, 0.16), true)
	draw_rect(selection_rect, Color(0.55, 0.92, 1.0, 0.95), false, 2.0)

func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_left_selection(event.shift_pressed)
		else:
			_finish_left_selection()
		get_viewport().set_input_as_handled()
	elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_issue_move_command()
		get_viewport().set_input_as_handled()

func _start_left_selection(is_additive: bool) -> void:
	_tracking_left_click = true
	_is_dragging = false
	_additive_selection = is_additive
	_drag_start = get_global_mouse_position()
	_drag_current = _drag_start

func _finish_left_selection() -> void:
	if not _tracking_left_click:
		return
	_drag_current = get_global_mouse_position()
	if _is_dragging:
		_select_in_rectangle(Rect2(_drag_start, _drag_current - _drag_start).abs())
	else:
		_select_at_point(_drag_current)
	_tracking_left_click = false
	_is_dragging = false
	queue_redraw()

func _select_at_point(world_position: Vector2) -> void:
	var unit := _find_unit_at(world_position)
	if unit == null:
		if not _additive_selection:
			clear_selection()
		return
	if _additive_selection:
		toggle_unit(unit)
	else:
		set_selection([unit])

func _select_in_rectangle(selection_rect: Rect2) -> void:
	var units_in_rectangle: Array[PlaceholderUnit] = []
	for unit in _get_selectable_units():
		if selection_rect.has_point(unit.global_position):
			units_in_rectangle.append(unit)
	if _additive_selection:
		for unit in units_in_rectangle:
			if not _selected_units.has(unit):
				_add_unit(unit)
	elif units_in_rectangle.is_empty():
		clear_selection()
	else:
		set_selection(units_in_rectangle)

func _find_unit_at(world_position: Vector2) -> PlaceholderUnit:
	var closest_unit: PlaceholderUnit
	var closest_distance := INF
	for unit in _get_selectable_units():
		if unit.contains_world_point(world_position):
			var distance := unit.global_position.distance_squared_to(world_position)
			if distance < closest_distance:
				closest_unit = unit
				closest_distance = distance
	return closest_unit

func _get_selectable_units() -> Array[PlaceholderUnit]:
	var units: Array[PlaceholderUnit] = []
	for node in get_tree().get_nodes_in_group(SELECTABLE_GROUP):
		if node is PlaceholderUnit and node.is_selectable:
			units.append(node)
	return units

func set_selection(units: Array[PlaceholderUnit]) -> void:
	clear_selection()
	for unit in units:
		_add_unit(unit)

func clear_selection() -> void:
	for unit in _selected_units:
		unit.set_selected(false)
	_selected_units.clear()

func toggle_unit(unit: PlaceholderUnit) -> void:
	if _selected_units.has(unit):
		_selected_units.erase(unit)
		unit.set_selected(false)
	else:
		_add_unit(unit)

func _add_unit(unit: PlaceholderUnit) -> void:
	_selected_units.append(unit)
	unit.set_selected(true)

func _issue_move_command() -> void:
	if _command_controller != null and not _selected_units.is_empty():
		_command_controller.issue_move(_selected_units, get_global_mouse_position())
