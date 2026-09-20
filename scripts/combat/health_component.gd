class_name HealthComponent
extends Node

signal damaged(amount: float)
signal died

@export var max_health := 100.0

var current_health := 0.0
var is_dead := false

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	current_health = maxf(0.0, current_health - amount)
	damaged.emit(amount)
	if current_health <= 0.0:
		is_dead = true
		died.emit()

func health_ratio() -> float:
	if max_health <= 0.0:
		return 0.0
	return current_health / max_health
