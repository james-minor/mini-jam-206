extends Node

@export var room_tile_presets: Array[PackedByteArray] = []
var _persistent_rooms_data: Dictionary[Vector2i, RoomData] = {}

func save_room_data(room: Vector2i, data: RoomData) -> void:
	_persistent_rooms_data.set(room, data)

func get_room_data(room: Vector2i) -> RoomData:
	return _persistent_rooms_data.get(room)

func generate_room(room: Vector2i) -> void:
	var room_data = RoomData.new()
	var tile_map_data = room_tile_presets[randi_range(0, room_tile_presets.size() - 1)].duplicate()
	room_data.tile_map = tile_map_data
	save_room_data(room, room_data)
