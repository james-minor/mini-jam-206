class_name PlayerStateDead
extends PlayerState

func on_enter_state() -> void:
	print("player has died")
	%PlayerSprite.play("die", 2)
	await %PlayerSprite.animation_finished
	
	SceneChanger.change_scene(load("res://scenes/game_over_screen/game_over_screen.tscn"))
