extends Area2D

@export
var chance_to_appear: int

func _ready() -> void:
	if randi_range(0, chance_to_appear) != chance_to_appear:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).heal()
		call_deferred("queue_free") 
