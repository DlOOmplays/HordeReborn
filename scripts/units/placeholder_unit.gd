class_name PlaceholderUnit
extends Node2D

@export var unit_name := "Unit"
@export var team_color := Color("4a9de0")

func _draw() -> void:
	# A silhouette placeholder; future animation, selection, and stats remain separate systems.
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
