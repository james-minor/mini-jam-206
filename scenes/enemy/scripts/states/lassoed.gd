extends EnemyState


func on_enter_state() -> void:
	%WorldCollider.disabled = true
	%EnemySprite.play("struggle")


func physics_process_state(delta: float) -> void:
	if enemy.global_position.distance_to(GlobalVariables.player_position) > 10:
		enemy.velocity = enemy.position.direction_to(GlobalVariables.player_position) * 5 / delta
		enemy.move_and_slide()
