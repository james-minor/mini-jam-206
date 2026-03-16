extends Node
enum RoomVisibility {
	EMPTY, #0
	UNSEEN, #1
	REVEALED, #2
	ENTERED, #3
	ACTIVE #4
}

var COLORS = [Color(255,246,211),Color(255,246,211),Color(124,63,88),Color(235,107,111),Color(249,168,117)]

var rooms: Array = []
var active_room

func _ready() -> void:
	DungeonGenerator.generation_complete.connect(_on_generation_completion)


func reveal_adjacent_rooms(center:Vector2i) -> void:
	var up = DungeonGenerator._convert_position_to_index(center + Vector2i.UP)
	var right = DungeonGenerator._convert_position_to_index(center + Vector2i.RIGHT)
	var down = DungeonGenerator._convert_position_to_index(center + Vector2i.DOWN)
	var left = DungeonGenerator._convert_position_to_index(center + Vector2i.LEFT)
	reveal_room(up)
	reveal_room(right)
	reveal_room(down)
	reveal_room(left)
	

func reveal_room(room: Vector2i) -> void:
	if not DungeonGenerator.is_valid_position(room): 
		return
	
	var room_index = DungeonGenerator._convert_position_to_index(room)
	if rooms[room_index] == RoomVisibility.UNSEEN:
		rooms[room_index] = RoomVisibility.REVEALED
	elif rooms[room_index] == RoomVisibility.ACTIVE:
		rooms[room_index] = RoomVisibility.ENTERED
 

func set_room_active(room: Vector2i) -> void:
	var index = DungeonGenerator._convert_position_to_index(room)
	rooms[active_room] = RoomVisibility.ENTERED
	rooms[index] = RoomVisibility.ACTIVE
	reveal_adjacent_rooms(room)


func _index_to_pos(index: int) -> Vector2i:
	return Vector2i(index / DungeonGenerator.DIMENSIONS.x, index % DungeonGenerator.DIMENSIONS.y)


func set_index_active(room: int) -> void:
	var vector = _index_to_pos(room)
	reveal_adjacent_rooms(vector)


func _on_generation_completion():
	#Get all non-empty rooms, add them to this dictionary with the same 
	var i = 0
	for room in DungeonGenerator._floor_room_types: #privacy shmivacy. I wanna use it
		if room == DungeonGenerator.RoomType.EMPTY:
			rooms.append(RoomVisibility.EMPTY)
		else:
			rooms.append(RoomVisibility.UNSEEN)
		if room == DungeonGenerator.RoomType.START:
			active_room = i
			rooms[i] = RoomVisibility.ACTIVE
		i += 1

	set_index_active(active_room)
