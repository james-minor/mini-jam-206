extends Node2D

@export
var lasso_speed: float = 500

@onready
var player: Player = owner as Player

func lasso_to_object() -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	var query = PhysicsRayQueryParameters2D.create(global_position, get_global_mouse_position(), 16)
	var result = space_state.intersect_ray(query)
	
	if result:
		print("moving!")
		%StateMachine.set_state("lassodash")
		
		%LassoLine.target_position = result["position"]
		player.velocity += player.global_position.direction_to(result["position"]) * lasso_speed
		
		player.move_and_slide()
