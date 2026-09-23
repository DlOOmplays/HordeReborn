class_name EnemyCombatAI
extends Node

@export var detection_range := 430.0
@export var retarget_interval := 0.5

var _retarget_remaining := 0.0

@onready var unit: PlaceholderUnit = get_parent() as PlaceholderUnit

func _physics_process(delta: float) -> void:
	if not is_instance_valid(unit) or unit.is_dead or unit.team != PlaceholderUnit.Team.ENEMY:
		return
	_retarget_remaining = maxf(0.0, _retarget_remaining - delta)
	if unit.combat != null and is_instance_valid(unit.combat) and unit.combat.has_valid_target():
		return
	if _retarget_remaining > 0.0:
		return
	_retarget_remaining = retarget_interval
	var target := _find_nearest_enemy()
	if target != null:
		unit.attack_target(target)

func _find_nearest_enemy() -> PlaceholderUnit:
	var closest_unit: PlaceholderUnit
	var closest_distance := detection_range
	for node in get_tree().get_nodes_in_group(&"combat_units"):
		if node is PlaceholderUnit and is_instance_valid(node):
			var candidate := node as PlaceholderUnit
			if not candidate.is_valid_combat_target() or candidate.team == unit.team:
				continue
			var distance := unit.global_position.distance_to(candidate.global_position)
			if distance < closest_distance:
				closest_unit = candidate
				closest_distance = distance
	return closest_unit
