extends EnemyState


var moving_to_player: bool
var launch_allowed: bool
@onready
var prev_position: Vector2 = enemy.position
var launch_velocity: Vector2 = Vector2(0,0)

func on_enter_state() -> void:
	moving_to_player = true
	launch_allowed = false
	
	%WorldCollider.disabled = true
	%EnemySprite.play("struggle")


func physics_process_state(delta: float) -> void:
	if moving_to_player:
		enemy.velocity = enemy.position.direction_to(GlobalVariables.player_position) * 5 / delta
		enemy.move_and_slide()
		
	if prev_position.distance_to(GlobalVariables.player_position) < 10:
		moving_to_player = false
		launch_allowed = true
	else:
		prev_position = enemy.position
