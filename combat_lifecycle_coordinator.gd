class_name CombatLifecycleCoordinator
extends Node

## Resolves cross-system references while the dying unit still exists in the scene.

@export var selection_controller_path: NodePath

@onready var _selection_controller: Node = get_node_or_null(selection_controller_path)

func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	for node in get_tree().get_nodes_in_group(&"combat_units"):
		_watch_unit(node)

func _on_node_added(node: Node) -> void:
	if node is PlaceholderUnit:
		call_deferred("_watch_unit", node)

func _watch_unit(node: Node) -> void:
	if not is_instance_valid(node) or not node is PlaceholderUnit:
		return
	var unit := node as PlaceholderUnit
	if unit.health != null and is_instance_valid(unit.health) and not unit.health.died.is_connected(_on_unit_died):
		unit.health.died.connect(_on_unit_died.bind(unit), CONNECT_ONE_SHOT)

func _on_unit_died(unit: PlaceholderUnit) -> void:
	if not is_instance_valid(unit):
		return
	_remove_from_selection(unit)
	_clear_attackers_targeting(unit)

func _remove_from_selection(unit: PlaceholderUnit) -> void:
	if _selection_controller == null or not is_instance_valid(_selection_controller):
		return
	var selected_units: Variant = _selection_controller.get("_selected_units")
	if selected_units is Array:
		selected_units.erase(unit)
		_selection_controller.set("_selected_units", selected_units)

func _clear_attackers_targeting(dead_unit: PlaceholderUnit) -> void:
	for node in get_tree().get_nodes_in_group(&"combat_units"):
		if not is_instance_valid(node) or not node is PlaceholderUnit:
			continue
		var attacker := node as PlaceholderUnit
		if attacker.combat == null or not is_instance_valid(attacker.combat):
			continue
		if attacker.combat.get("_target") == dead_unit:
			attacker.combat.clear_target()
