class_name Enemy
extends CharacterBody2D

@export
var health: float = 500 :
	set = _set_health

func get_lassoed() -> void:
	%StateMachine.set_state("lassoed")


func throw(direction: Vector2, power: float) -> void:
	velocity = direction * power
	%StateMachine.set_state("moving")
	%StateMachine.set_state("thrown")
	

func _set_health(value: float) -> void:
	health = value
	if health <= 0:
		%StateMachine.set_state("dead")
