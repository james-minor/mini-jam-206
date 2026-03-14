extends Node

var room_data: Dictionary[Vector2i, PackedByteArray] = {}

func clear_room_data() -> void:
	room_data.clear()
