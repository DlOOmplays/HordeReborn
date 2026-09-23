extends SceneTree

const MAIN_SCENE := preload("res://scenes/main/main.tscn")

func _initialize() -> void:
	var main := MAIN_SCENE.instantiate()
	root.add_child(main)
	await process_frame
	await process_frame
	var navigation_region := main.get_node_or_null("TestWorld/NavigationRegion2D") as NavigationRegion2D
	assert(navigation_region != null, "The test world must create its NavigationRegion2D.")
	assert(navigation_region.navigation_polygon != null, "The navigation region must have a polygon.")
	assert(navigation_region.navigation_polygon.get_polygon_count() > 0, "The navigation polygon must contain walkable cells.")
	var unit := main.get_node("PlaceholderUnits/Worker") as PlaceholderUnit
	assert(unit.navigation_agent != null, "Units must provide NavigationAgent2D.")
	unit.command_move(Vector2(2200, 1450))
	await physics_frame
	assert(unit.navigation_agent.target_position == Vector2(2200, 1450), "Move commands must update the navigation target.")
	quit()
