class_name Player
extends CharacterBody2D


func _ready() -> void:
	match PlayerTracker.entering_direction:
		Vector2i.DOWN:
			global_position = Vector2(-8, -104)
		Vector2i.RIGHT:
			global_position = Vector2(-120, -24)
		Vector2i.LEFT:
			global_position = Vector2(104, -24)
		Vector2i.UP:
			global_position = Vector2(-8, 56)

func _process(_delta: float) -> void:
	GlobalVariables.player_position = global_position
