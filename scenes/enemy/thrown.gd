extends EnemyState

func physics_process_state(delta: float) -> void:
	enemy.move_and_slide()
	enemy.velocity *= .97
	if enemy.velocity.distance_to(Vector2(0,0)) < 3:
		transition_to("moving")
