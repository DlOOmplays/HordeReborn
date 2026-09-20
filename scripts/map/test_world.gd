extends Node2D

const MAP_SIZE := Vector2(3200, 2000)
const GRID_SIZE := 80.0

func _draw() -> void:
	# The procedural field keeps this foundation asset-free and easy to replace with TileMap layers.
	draw_rect(Rect2(Vector2.ZERO, MAP_SIZE), Color("315c40"))
	_draw_grid()
	_draw_water()
	_draw_terrain_props()

func _draw_grid() -> void:
	var grid_color := Color(0.18, 0.34, 0.24, 0.4)
	for x in range(0, int(MAP_SIZE.x) + 1, int(GRID_SIZE)):
		draw_line(Vector2(x, 0), Vector2(x, MAP_SIZE.y), grid_color, 1.0)
	for y in range(0, int(MAP_SIZE.y) + 1, int(GRID_SIZE)):
		draw_line(Vector2(0, y), Vector2(MAP_SIZE.x, y), grid_color, 1.0)

func _draw_water() -> void:
	var river := PackedVector2Array([Vector2(0, 390), Vector2(600, 465), Vector2(1200, 410), Vector2(1900, 510), Vector2(2600, 435), Vector2(3200, 490)])
	draw_polyline(river, Color("4d8fa3"), 145.0, true)
	draw_polyline(river, Color("8bc5cc"), 3.0, true)

func _draw_terrain_props() -> void:
	var trees := [Vector2(420, 700), Vector2(510, 760), Vector2(580, 660), Vector2(2270, 880), Vector2(2360, 790), Vector2(2450, 910), Vector2(2700, 1330), Vector2(2780, 1415)]
	for tree_position in trees:
		draw_circle(tree_position + Vector2(5, 9), 31.0, Color(0.08, 0.18, 0.10, 0.4))
		draw_circle(tree_position, 29.0, Color("1d5632"))
		draw_circle(tree_position - Vector2(8, 10), 15.0, Color("3d8045"))
	var rocks := [Vector2(920, 1260), Vector2(1010, 1320), Vector2(1940, 1430), Vector2(2030, 1370)]
	for rock_position in rocks:
		draw_circle(rock_position, 24.0, Color("69777a"))
		draw_circle(rock_position - Vector2(6, 7), 9.0, Color("aab4ae"))
