class_name DungeonRoom
extends Node2D

const NORTH_DOOR_POSITION: Vector2i = Vector2i(0, -3)

func _ready() -> void:
	check_doors()


func check_doors() -> void:
	# Checking north door.
	if not _should_door_exist(Vector2i.UP):
		%NorthDoor.disable()
	
	# Checking east door.
	if not _should_door_exist(Vector2i.RIGHT):
		%EastDoor.disable()
	
	# Checking south door.
	if not _should_door_exist(Vector2i.DOWN):
		%SouthDoor.disable()
	
	# Checking west door.
	if not _should_door_exist(Vector2i.LEFT):
		%WestDoor.disable()


func _should_door_exist(direction: Vector2i) -> bool:
	if not DungeonGenerator.is_valid_position(PlayerTracker.current_room + direction):
		return false
	
	if DungeonGenerator.get_room_type(PlayerTracker.current_room + direction) == DungeonGenerator.RoomType.EMPTY:
		return false
	
	return true
