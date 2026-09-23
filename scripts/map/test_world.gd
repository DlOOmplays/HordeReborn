extends Node2D

const MAP_SIZE := Vector2(3200, 2000)
const GRID_SIZE := 80.0
const RIVER_BOUNDS := Rect2(0, 350, 3200, 210)
const WALL_BOUNDS := Rect2(1800, 720, 140, 560)
const TREE_POSITIONS := [Vector2(420, 700), Vector2(510, 760), Vector2(580, 660), Vector2(2270, 880), Vector2(2360, 790), Vector2(2450, 910), Vector2(2700, 1330), Vector2(2780, 1415)]
const ROCK_POSITIONS := [Vector2(920, 1260), Vector2(1010, 1320), Vector2(1940, 1430), Vector2(2030, 1370)]

var _navigation_region: NavigationRegion2D

func _ready() -> void:
	_create_navigation_region()

func _draw() -> void:
	# The procedural field keeps this foundation asset-free and easy to replace with TileMap layers.
	draw_rect(Rect2(Vector2.ZERO, MAP_SIZE), Color("315c40"))
	_draw_grid()
	_draw_water()
	_draw_terrain_props()
	_draw_barrier()

func _create_navigation_region() -> void:
	_navigation_region = NavigationRegion2D.new()
	_navigation_region.name = "NavigationRegion2D"
	_navigation_region.navigation_polygon = _build_navigation_polygon()
	add_child(_navigation_region)

func _build_navigation_polygon() -> NavigationPolygon:
	var navigation_polygon := NavigationPolygon.new()
	var vertices := PackedVector2Array()
	var cell_size := int(GRID_SIZE)
	for y in range(0, int(MAP_SIZE.y), cell_size):
		for x in range(0, int(MAP_SIZE.x), cell_size):
			var cell := Rect2(x, y, cell_size, cell_size)
			if _is_navigation_blocked(cell.get_center()):
				continue
			var base_index := vertices.size()
			vertices.append_array(PackedVector2Array([cell.position, Vector2(cell.end.x, cell.position.y), cell.end, Vector2(cell.position.x, cell.end.y)]))
			navigation_polygon.add_polygon(PackedInt32Array([base_index, base_index + 1, base_index + 2, base_index + 3]))
	navigation_polygon.vertices = vertices
	return navigation_polygon

func _is_navigation_blocked(point: Vector2) -> bool:
	if RIVER_BOUNDS.has_point(point) or WALL_BOUNDS.grow(24.0).has_point(point):
		return true
	for tree_position in TREE_POSITIONS:
		if point.distance_to(tree_position) < 56.0:
			return true
	for rock_position in ROCK_POSITIONS:
		if point.distance_to(rock_position) < 48.0:
			return true
	return point.x < 40.0 or point.y < 40.0 or point.x > MAP_SIZE.x - 40.0 or point.y > MAP_SIZE.y - 40.0

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
	for tree_position in TREE_POSITIONS:
		draw_circle(tree_position + Vector2(5, 9), 31.0, Color(0.08, 0.18, 0.10, 0.4))
		draw_circle(tree_position, 29.0, Color("1d5632"))
		draw_circle(tree_position - Vector2(8, 10), 15.0, Color("3d8045"))
	for rock_position in ROCK_POSITIONS:
		draw_circle(rock_position, 24.0, Color("69777a"))
		draw_circle(rock_position - Vector2(6, 7), 9.0, Color("aab4ae"))

func _draw_barrier() -> void:
	draw_rect(WALL_BOUNDS, Color("50463f"), true)
	draw_rect(WALL_BOUNDS, Color("b08c65"), false, 4.0)
	for y in range(int(WALL_BOUNDS.position.y) + 18, int(WALL_BOUNDS.end.y), 36):
		draw_line(Vector2(WALL_BOUNDS.position.x + 8, y), Vector2(WALL_BOUNDS.end.x - 8, y), Color("756052"), 2.0)
