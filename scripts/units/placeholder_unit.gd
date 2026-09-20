class_name PlaceholderUnit
extends Node2D

enum Team { PLAYER, ENEMY }

@export var unit_name := "Unit"
@export var team_color := Color("4a9de0")
@export var team: Team = Team.PLAYER
@export var movement_speed := 220.0
@export var arrival_distance := 4.0
@export var personal_space := 36.0
@export var playable_bounds := Rect2(0, 0, 3200, 2000)

var is_selectable := false
var is_selected := false
var is_dead := false
var _destination := Vector2.ZERO
var _has_destination := false
var _hit_flash_remaining := 0.0
var _attack_flash_remaining := 0.0

@onready var health: HealthComponent = get_node_or_null("HealthComponent") as HealthComponent
@onready var combat: CombatComponent = get_node_or_null("CombatComponent") as CombatComponent

func _ready() -> void:
	add_to_group(&"selectable_units")
	add_to_group(&"combat_units")
	is_selectable = team == Team.PLAYER
	if health != null:
		health.damaged.connect(_on_damaged)
		health.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	var velocity := _movement_velocity()
	velocity += _separation_velocity()
	if velocity != Vector2.ZERO:
		global_position += velocity * delta
		global_position = global_position.clamp(playable_bounds.position, playable_bounds.end)

func _process(delta: float) -> void:
	if _hit_flash_remaining > 0.0 or _attack_flash_remaining > 0.0:
		_hit_flash_remaining = maxf(0.0, _hit_flash_remaining - delta)
		_attack_flash_remaining = maxf(0.0, _attack_flash_remaining - delta)
		queue_redraw()

func move_to(destination: Vector2) -> void:
	if is_dead:
		return
	_destination = destination.clamp(playable_bounds.position, playable_bounds.end)
	_has_destination = true

func command_move(destination: Vector2) -> void:
	if combat != null:
		combat.clear_target()
	move_to(destination)

func stop_movement() -> void:
	_has_destination = false

func attack_target(target: PlaceholderUnit) -> void:
	if is_dead or combat == null:
		return
	combat.set_target(target)

func receive_attack(amount: float) -> void:
	if health != null:
		health.take_damage(amount)

func is_valid_combat_target() -> bool:
	return not is_dead and health != null and not health.is_dead and is_inside_tree()

func show_attack_feedback() -> void:
	_attack_flash_remaining = 0.12
	queue_redraw()

func set_selected(value: bool) -> void:
	if is_dead:
		return
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
	if _attack_flash_remaining > 0.0:
		draw_arc(Vector2.ZERO, 28.0, 0.0, TAU, 20, Color(1.0, 0.72, 0.25, 0.9), 2.0, true)
	if _hit_flash_remaining > 0.0:
		draw_circle(Vector2.ZERO, 19.0, Color(1.0, 1.0, 1.0, 0.45))
	_draw_ellipse_polygon(Vector2(0, 15), Vector2(22, 8), Color(0.05, 0.08, 0.06, 0.35))
	draw_circle(Vector2.ZERO, 17.0, Color("17232c"))
	draw_circle(Vector2.ZERO, 14.0, team_color)
	draw_circle(Vector2(-5, -5), 4.5, Color(1, 1, 1, 0.35))
	draw_arc(Vector2.ZERO, 20.0, 0.0, TAU, 20, Color("d9efe3"), 1.5, true)
	_draw_health_bar()

func _draw_health_bar() -> void:
	if health == null or (not is_selected and health.current_health >= health.max_health):
		return
	var bar_rect := Rect2(-20, -34, 40, 6)
	draw_rect(bar_rect, Color(0.08, 0.08, 0.08, 0.9), true)
	draw_rect(Rect2(bar_rect.position + Vector2(1, 1), Vector2(38 * health.health_ratio(), 4)), Color("5ed15e"), true)

func _on_damaged(_amount: float) -> void:
	_hit_flash_remaining = 0.16
	queue_redraw()

func _on_died() -> void:
	if is_dead:
		return
	is_dead = true
	is_selectable = false
	is_selected = false
	_has_destination = false
	remove_from_group(&"selectable_units")
	remove_from_group(&"combat_units")
	modulate = Color(0.3, 0.3, 0.3, 1.0)
	var fade_tween := create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.55)
	fade_tween.tween_callback(queue_free)

func _draw_ellipse_polygon(center: Vector2, radii: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in 24:
		var angle := TAU * float(index) / 24.0
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(points, color)
