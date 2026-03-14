extends Node
## Tracks persistant player information throughout scene changes such as the
## current floor, current room position, etc.

## Emitted when the current room changes.
signal current_room_changed()

## Emitted when the current floor changes.
signal current_floor_changed()

## The position of the current room the player is in within the current floor.
var current_room: Vector2i :
	set = _set_current_room

var current_floor: int = 1 :
	set = _set_current_floor


func _ready() -> void:
	DungeonGenerator.generation_complete.connect(_on_floor_generation_complete)


## Returns the RoomType of the room the player is currently in.
func get_current_room_type() -> DungeonGenerator.RoomType:
	return DungeonGenerator.get_dungeon_data(current_room)


func _on_floor_generation_complete() -> void:
	current_room = DungeonGenerator.entrance_position


func _set_current_room(value: Vector2i) -> void:
	current_room = value
	current_room_changed.emit()


func _set_current_floor(value: int) -> void:
	current_floor = value
	current_floor_changed.emit()
