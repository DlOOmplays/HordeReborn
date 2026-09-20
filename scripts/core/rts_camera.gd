class_name RTSCamera
extends Camera2D

@export var pan_speed := 850.0
@export var zoom_step := 0.12
@export var minimum_zoom := 0.55
@export var maximum_zoom := 1.5
@export var map_bounds := Rect2(0, 0, 3200, 2000)

func _process(delta: float) -> void:
	var movement := Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if movement != Vector2.ZERO:
		position += movement * pan_speed * delta / zoom.x
		position.x = clampf(position.x, map_bounds.position.x, map_bounds.end.x)
		position.y = clampf(position.y, map_bounds.position.y, map_bounds.end.y)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_set_zoom(zoom.x - zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_set_zoom(zoom.x + zoom_step)

func _set_zoom(value: float) -> void:
	var clamped_zoom := clampf(value, minimum_zoom, maximum_zoom)
	zoom = Vector2(clamped_zoom, clamped_zoom)
