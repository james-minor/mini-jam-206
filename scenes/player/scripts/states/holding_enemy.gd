class_name PlayerStateHoldingEnemy
extends PlayerState

@export
var throw_power: float

var held_enemy: Enemy

func on_enter_state() -> void:
	%LassoLine.visible = true


func input_state(event: InputEvent) -> void:
	if event.is_action_pressed("lasso"):
		if held_enemy.global_position.distance_to(player.global_position) > 15:
			print("too far to throw")
			return
		
		held_enemy.throw(player.global_position.direction_to(player.get_global_mouse_position()), throw_power)
		transition_to("moving")


func process_state(delta: float) -> void:
	if held_enemy.global_position.distance_to(player.global_position) < 15:
		%ThrowIndicator.visible = true
	
	%LassoLine.target_position = held_enemy.global_position


func on_exit_state() -> void:
	%ThrowIndicator.visible = false
	%LassoLine.visible = false
