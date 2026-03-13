class_name PlayerState
extends State

@onready
var player: Player = owner as Player

func _ready() -> void:
	assert(owner is Player, "PlayerState must have a Player object as owner!")
