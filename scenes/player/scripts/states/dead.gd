class_name PlayerStateDead
extends PlayerState

func on_enter_state() -> void:
	print("player has died")
	%PlayerSprite.play("die", 2)
