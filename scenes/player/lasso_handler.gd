extends Node2D

## The minimum length the lasso needs to be to work.
@export
var min_lasso_length: float

## The maximum distance the player can lasso to / from.
@export
var max_lasso_length: float

## How fast the lasso pulls an object / the player.
@export
var lasso_speed: float

## Reference to the player owner object.
@onready
var _player: Player = owner as Player

func lasso_to_object() -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	%InvalidLassoTarget.pitch_scale = randf_range(0.9, 1.1)
	
	if global_position.distance_to(get_global_mouse_position()) < min_lasso_length:
		return
	
	if global_position.distance_to(get_global_mouse_position()) > max_lasso_length:
		%InvalidLassoTarget.play()
		return
	
	var query = PhysicsRayQueryParameters2D.create(global_position, get_global_mouse_position(), 16)
	var result = space_state.intersect_ray(query)
	
	if result:
		%StateMachine.set_state("lassodash")
		
		%LassoLine.target_position = result["position"]
		_player.velocity += _player.global_position.direction_to(result["position"]) * lasso_speed
		
		_player.move_and_slide()
		
		%SuccessfulLasso.pitch_scale = randf_range(0.9, 1.1)
		%SuccessfulLasso.play()
	else:
		%InvalidLassoTarget.play()
