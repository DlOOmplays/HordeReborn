extends Control

func _draw() -> void:
	var panel := Rect2(20, 20, 335, 92)
	draw_style_box(_panel_style(Color(0.04, 0.08, 0.07, 0.85)), panel)
	draw_string(ThemeDB.fallback_font, Vector2(38, 51), "HORDE REBORN", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("e8d9a6"))
	draw_string(ThemeDB.fallback_font, Vector2(38, 78), "Phase 0  •  RTS test environment", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("c4d3c7"))
	draw_string(ThemeDB.fallback_font, Vector2(38, 101), "Select: left / drag / shift   •   Move: right-click", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("91b3a0"))

func _panel_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color("6e8f70")
	return style
