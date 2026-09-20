class_name CombatComponent
extends Node

@export var attack_damage := 14.0
@export var attack_range := 42.0
@export var attack_cooldown := 0.8

var _target: PlaceholderUnit
var _cooldown_remaining := 0.0

@onready var unit: PlaceholderUnit = get_parent() as PlaceholderUnit

func _physics_process(delta: float) -> void:
	if unit == null or unit.is_dead:
		return
	_cooldown_remaining = maxf(0.0, _cooldown_remaining - delta)
	if not has_valid_target():
		_target = null
		return
	if unit.global_position.distance_to(_target.global_position) > attack_range:
		unit.move_to(_target.global_position)
		return
	unit.stop_movement()
	if _cooldown_remaining <= 0.0:
		_target.receive_attack(attack_damage)
		unit.show_attack_feedback()
		_cooldown_remaining = attack_cooldown

func set_target(target: PlaceholderUnit) -> void:
	if _is_valid_target(target):
		_target = target
	else:
		_target = null

func clear_target() -> void:
	_target = null

func has_valid_target() -> bool:
	return _is_valid_target(_target)

func _is_valid_target(target: PlaceholderUnit) -> bool:
	return target != null and is_instance_valid(target) and target.is_valid_combat_target() and target.team != unit.team
