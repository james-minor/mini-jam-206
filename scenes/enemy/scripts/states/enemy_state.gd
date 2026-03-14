class_name EnemyState
extends State

@onready
var enemy: Enemy = owner as Enemy

func _ready() -> void:
	assert(owner is Enemy, "EnemyState must have an Enemy object as owner!")
