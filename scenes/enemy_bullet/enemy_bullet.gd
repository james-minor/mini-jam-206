class_name EnemyBullet
extends CharacterBody2D

var _target_position: Vector2 = Vector2.ZERO


func set_target_position(target: Vector2) -> void:
	_target_position = target
	velocity = global_position.direction_to(_target_position) * 85
	look_at(_target_position)


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		if collision.get_collider() is Player:
			(collision.get_collider() as Player).damage()
			pass
		 
		call_deferred("queue_free")
