class_name PlaceholderUnit
extends Node2D

@export var unit_name := "Unit"
@export var team_color := Color("4a9de0")
@export var movement_speed := 220.0
@export var arrival_distance := 4.0
@export var personal_space := 36.0
@export var playable_bounds := Rect2(0, 0, 3200, 2000)

var is_selectable := true
var is_selected := false
var _destination := Vector2.ZERO
var _has_destination := false

func _ready() -> void:
	add_to_group(&"selectable_units")

func _physics_process(delta: float) -> void:
	var velocity := _movement_velocity()
	velocity += _separation_velocity()
	if velocity != Vector2.ZERO:
		global_position += velocity * delta
		global_position = global_position.clamp(playable_bounds.position, playable_bounds.end)

func move_to(destination: Vector2) -> void:
	_destination = destination.clamp(playable_bounds.position, playable_bounds.end)
	_has_destination = true

func set_selected(value: bool) -> void:
	if is_selected == value:
		return
	is_selected = value
	queue_redraw()

func contains_world_point(world_position: Vector2) -> bool:
	return global_position.distance_squared_to(world_position) <= 24.0 * 24.0

func _movement_velocity() -> Vector2:
	if not _has_destination:
		return Vector2.ZERO
	var distance := global_position.distance_to(_destination)
	if distance <= arrival_distance:
		global_position = _destination
		_has_destination = false
		return Vector2.ZERO
	return global_position.direction_to(_destination) * movement_speed

func _separation_velocity() -> Vector2:
	var separation := Vector2.ZERO
	for node in get_tree().get_nodes_in_group(&"selectable_units"):
		if node == self or not node is PlaceholderUnit:
			continue
		var other_unit := node as PlaceholderUnit
		var offset := global_position - other_unit.global_position
		var distance := offset.length()
		if distance > 0.0 and distance < personal_space:
			separation += offset.normalized() * (personal_space - distance) * 5.0
	return separation

func _draw() -> void:
	# A silhouette placeholder; future animation, selection, and stats remain separate systems.
	if is_selected:
		draw_arc(Vector2(0, 11), 25.0, 0.0, TAU, 28, Color(0.9, 0.95, 0.35, 0.95), 2.5, true)
	_draw_ellipse_polygon(Vector2(0, 15), Vector2(22, 8), Color(0.05, 0.08, 0.06, 0.35))
	draw_circle(Vector2.ZERO, 17.0, Color("17232c"))
	draw_circle(Vector2.ZERO, 14.0, team_color)
	draw_circle(Vector2(-5, -5), 4.5, Color(1, 1, 1, 0.35))
	draw_arc(Vector2.ZERO, 20.0, 0.0, TAU, 20, Color("d9efe3"), 1.5, true)

func _draw_ellipse_polygon(center: Vector2, radii: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in 24:
		var angle := TAU * float(index) / 24.0
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(points, color)
