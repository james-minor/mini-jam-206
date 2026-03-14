class_name PlayerStateLassoDash
extends PlayerState

func on_enter_state() -> void:
	%LassoLine.visible = true


func physics_process_state(delta: float) -> void:
	if player.velocity.is_zero_approx():
		transition_to("moving")
	
	var collision: KinematicCollision2D = player.move_and_collide(player.velocity * delta)
	if collision: 
		transition_to("moving")


func on_exit_state() -> void:
	%LassoLine.visible = false
