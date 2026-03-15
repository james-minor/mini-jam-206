class_name DungeonRoom
extends Node2D

func _ready() -> void:
	check_doors()


func check_doors() -> void:
	# Checking north door.
	if not _should_door_exist(%NorthDoor.direction):
		%NorthDoor.disable()
	
	# Checking east door.
	if not _should_door_exist(%EastDoor.direction):
		%EastDoor.disable()
	
	# Checking south door.
	if not _should_door_exist(%SouthDoor.direction):
		%SouthDoor.disable()
	
	# Checking west door.
	if not _should_door_exist(%WestDoor.direction):
		%WestDoor.disable()


func _should_door_exist(direction: Vector2i) -> bool:
	if not DungeonGenerator.is_valid_position(PlayerTracker.current_room + direction):
		return false
	
	if DungeonGenerator.get_room_type(PlayerTracker.current_room + direction) == DungeonGenerator.RoomType.EMPTY:
		return false
	
	return true
