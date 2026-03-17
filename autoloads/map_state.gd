extends Node


enum RoomVisibility {
	EMPTY, #0
	UNSEEN, #1
	REVEALED, #2
	ENTERED, #3
	ACTIVE #4
}


var rooms: Array = []
var active_room


func _ready() -> void:
	DungeonGenerator.generation_complete.connect(_on_generation_completion)


func reveal_adjacent_rooms(center:Vector2i) -> void:
	var down = center + Vector2i.UP
	var left = center + Vector2i.RIGHT
	var up = center + Vector2i.DOWN
	var right = center + Vector2i.LEFT
	reveal_room(up)
	reveal_room(right)
	reveal_room(down)
	reveal_room(left)
	

func reveal_room(room: Vector2i) -> void:
	if not DungeonGenerator.is_room(room): 
		return
	
	var room_index = DungeonGenerator._convert_position_to_index(Vector2i(room.x, room.y))
	if rooms[room_index] == RoomVisibility.UNSEEN:
		rooms[room_index] = RoomVisibility.REVEALED
	elif rooms[room_index] == RoomVisibility.ACTIVE:
		rooms[room_index] = RoomVisibility.ENTERED
 

func set_room_active(room: Vector2i) -> void:
	var index = DungeonGenerator._convert_position_to_index(room)
	rooms[DungeonGenerator._convert_position_to_index((active_room))] = RoomVisibility.ENTERED
	rooms[index] = RoomVisibility.ACTIVE
	reveal_adjacent_rooms(room)


#func reset_map():
	#for room in rooms:
		#room 


func _on_generation_completion():
	rooms = []
	#Get all non-empty rooms, add them to this dictionary with the same 
	for room in DungeonGenerator._floor_room_types: #privacy shmivacy. I wanna use it
		if room == DungeonGenerator.RoomType.EMPTY:
			rooms.append(RoomVisibility.EMPTY)
		else:
			rooms.append(RoomVisibility.UNSEEN)
	active_room = PlayerTracker.current_room
	set_room_active(PlayerTracker.current_room)
