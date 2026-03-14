class_name PlayerStateDashing
extends PlayerState

@export
var dash_distance: float = 30.0

var _initial_position: Vector2

func on_enter_state() -> void:
	player.velocity *= 1.3
	_initial_position = player.global_position


func physics_process_state(delta: float) -> void:
	player.move_and_slide()
	
	if player.velocity.is_zero_approx():
		transition_to("moving")
	
	var collision: KinematicCollision2D = player.move_and_collide(player.velocity * delta)
	if collision: 
		transition_to("moving")
	
	if player.global_position.distance_to(_initial_position) > dash_distance:
		transition_to("moving")
