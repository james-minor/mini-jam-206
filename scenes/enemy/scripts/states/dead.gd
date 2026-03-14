class_name EnemyStateDead
extends EnemyState

func on_enter_state() -> void:
	print("enemy has died")
	%EnemySprite.play("die", 2)
