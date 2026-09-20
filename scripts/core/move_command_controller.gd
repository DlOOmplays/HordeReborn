class_name MoveCommandController
extends Node2D

@export var playable_bounds := Rect2(0, 0, 3200, 2000)
@export var formation_spacing := 54.0

var _marker_position := Vector2.ZERO
var _has_marker := false

func issue_move(units: Array[PlaceholderUnit], requested_destination: Vector2) -> void:
	if units.is_empty():
		return
	var destination := _clamp_to_playable_bounds(requested_destination)
	var offsets := _create_formation_offsets(units.size())
	for index in units.size():
		units[index].move_to(_clamp_to_playable_bounds(destination + offsets[index]))
	_marker_position = destination
	_has_marker = true
	queue_redraw()

func _draw() -> void:
	if not _has_marker:
		return
	var marker_color := Color(0.95, 0.84, 0.35, 0.95)
	draw_arc(_marker_position, 20.0, 0.0, TAU, 28, marker_color, 2.0, true)
	draw_line(_marker_position - Vector2(28, 0), _marker_position + Vector2(28, 0), marker_color, 2.0)
	draw_line(_marker_position - Vector2(0, 28), _marker_position + Vector2(0, 28), marker_color, 2.0)

func _create_formation_offsets(unit_count: int) -> Array[Vector2]:
	var offsets: Array[Vector2] = []
	for index in unit_count:
		if index == 0:
			offsets.append(Vector2.ZERO)
			continue
		var radius := formation_spacing * sqrt(float(index))
		var angle := float(index) * 2.39996323 # Golden angle distributes units evenly around the order point.
		offsets.append(Vector2(cos(angle), sin(angle)) * radius)
	return offsets

func _clamp_to_playable_bounds(world_position: Vector2) -> Vector2:
	return world_position.clamp(playable_bounds.position, playable_bounds.end)
