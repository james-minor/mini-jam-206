extends Line2D

var target_position: Vector2 = Vector2.ZERO


func _process(_delta: float) -> void:
	points[1] = to_local(target_position)
