extends Node2D

## The maximum distance the player can lasso to / from.
@export
var max_lasso_length: float

## How fast the lasso pulls an object / the player.
@export
var lasso_speed: float

## Reference to the player owner object.
@onready
var _player: Player = owner as Player

func _ready() -> void:
	GlobalVariables.max_lasso_length = self.max_lasso_length

func lasso_to_object() -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	%InvalidLassoTarget.pitch_scale = randf_range(0.9, 1.1)
	
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
		
func lasso_enemy() -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	if global_position.distance_to(get_global_mouse_position()) > max_lasso_length:
		return
	
	var query = PhysicsRayQueryParameters2D.create(global_position, get_global_mouse_position(), 16)
	var result = space_state.intersect_ray(query)
	
	if result and result.collider is Enemy:
		print("Lassoing enemy...")
		#%StateMachine.set_state("lassoenemy")
		#
		#%LassoLine.target_position = result["position"]
		#_player.velocity += _player.global_position.direction_to(result["position"]) * lasso_speed
		#
		#_player.move_and_slide()
	elif result:
		print("Can't lasso enemy of type %s" % [typeof(result.collider)])
		%SuccessfulLasso.pitch_scale = randf_range(0.9, 1.1)
		%SuccessfulLasso.play()
	else:
		%InvalidLassoTarget.play()
