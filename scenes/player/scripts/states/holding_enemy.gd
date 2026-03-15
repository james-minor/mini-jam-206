class_name PlayerStateHoldingEnemy
extends PlayerState

@export
var throw_power: float

var held_enemy: Enemy

func on_enter_state() -> void:
	%ThrowIndicator.visible = true
	%LassoLine.visible = true


func input_state(event: InputEvent) -> void:
	if event.is_action_pressed("lasso"):
		held_enemy.throw(player.global_position.direction_to(player.get_global_mouse_position()), throw_power)
		transition_to("moving")


func process_state(delta: float) -> void:
	%LassoLine.target_position = held_enemy.global_position


func on_exit_state() -> void:
	%ThrowIndicator.visible = false
	%LassoLine.visible = false
