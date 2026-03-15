extends EnemyState

func physics_process_state(delta: float) -> void:
	enemy.velocity *= .99
	var collision: KinematicCollision2D = enemy.move_and_collide(enemy.velocity * delta)
	
	if collision: 
		print("wowza")
		
		%HurtSoundEffect.pitch_scale = randf_range(0.9, 1.1)
		%HurtSoundEffect.play()
		
		enemy.velocity *= 0.6
		enemy.velocity *= Vector2.ONE.bounce(collision.get_normal())
		enemy.health -= enemy.velocity.length()
	
	
	if enemy.velocity.distance_to(Vector2(0,0)) < 3:
		%WorldCollider.disabled = false
		transition_to("moving")
