extends Node
## Handles the floor map generation.

## Emits when the floor generation has been completed.
signal generation_complete()

enum RoomType {
	## An empty room cell.
	EMPTY,
	## A default room.
	NORMAL,
	## The room where the player enters the floor.
	START,
	## The room with the floor exit.
	EXIT,
}

## Size of the dungeon floor map.
const DIMENSIONS: Vector2i = Vector2i(10, 5)

## Position of the starting room for the current dungeon floor.
var entrance_position: Vector2i = Vector2i(-1, -1)

## The shortest possible path the player can take from the floor entrance to exit.
var critical_path_length: int = 15

## Number of branching paths that can be created off of the critical path.
var branches: int = 3

## The minimum and maximum length of a branch.
var branch_length: Vector2i = Vector2i(1, 4)

var _branch_candidates: Array[Vector2i]

var _dungeon: Array[RoomType] = []


func _ready() -> void:
	generate_floor()
	print(self)


func _to_string() -> String:
	var output: String = ""
	for y in range(DIMENSIONS.y - 1, -1, -1):
		for x in DIMENSIONS.x:
			if get_dungeon_data(Vector2i(x, y)) == RoomType.EMPTY:
				output += "[ ]"
			else:
				output += "[" + str(get_dungeon_data(Vector2i(x, y))) + "]"
		output += "\n"
	return output


## Helper function that returns the data in the dungeon array for a specific room position.
func get_dungeon_data(position: Vector2i) -> RoomType:
	return _dungeon[_convert_position_to_index(position)]


## Helper function that sets the data for a room.
func set_dungeon_data(position: Vector2i, value: RoomType) -> void:
	_dungeon[_convert_position_to_index(position)] = value


## Generates a dungeon floor.
func generate_floor() -> void:
	_initialize_dungeon()
	_place_entrance()
	_generate_critical_path(entrance_position, critical_path_length, RoomType.NORMAL)
	_generate_branch()
	_place_exit()
	
	generation_complete.emit()


# Helper function that converts a room's 2D position to its corresponding index
# in the dungeon data array.
func _convert_position_to_index(position: Vector2i) -> int:
	return position.x * DIMENSIONS.y + position.y


func _initialize_dungeon() -> void:
	_dungeon = []
	
	for x in DIMENSIONS.x:
		for y in DIMENSIONS.y:
			_dungeon.append(RoomType.EMPTY)


func _place_entrance() -> void:
	if not _is_valid_position(entrance_position):
		entrance_position.x = randi_range(0, DIMENSIONS.x - 1)
		entrance_position.y = randi_range(0, DIMENSIONS.y - 1)
	
	set_dungeon_data(Vector2i(entrance_position.x, entrance_position.y), RoomType.START)


func _generate_critical_path(current: Vector2i, length: int, room_type: RoomType) -> bool:
	if length == 0: 
		return true
	
	if current == null:
		current = entrance_position
	
	var possible_directions = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
	var direction : Vector2i = possible_directions[randi_range(0, 3)]
	
	for i in 4:
		if _is_valid_position(current + direction) and get_dungeon_data(Vector2i(current.x + direction.x, current.y + direction.y)) == RoomType.EMPTY:
			current += direction
			if length > 1:
				set_dungeon_data(Vector2i(current.x, current.y), room_type)
			_branch_candidates.append(current)
			if _generate_critical_path(current, length - 1, room_type):
				return true
			else:
				_branch_candidates.erase(current)
				set_dungeon_data(Vector2i(current.x, current.y), RoomType.EMPTY)
				current -= direction
		direction = Vector2(direction.y, -direction.x)
	
	return false


func _generate_branch() -> void:
	var branches_created : int = 0
	var candidate : Vector2i
	while branches_created < branches and _branch_candidates.size():
		candidate = _branch_candidates[randi_range(0, _branch_candidates.size() - 1)]
		if _generate_critical_path(candidate, randi_range(branch_length.x, branch_length.y), RoomType.NORMAL):
			branches_created += 1
		else:
			_branch_candidates.erase(candidate)


func _place_exit() -> void:
	var exit = _branch_candidates[randi_range(0, _branch_candidates.size() - 1)]
	_branch_candidates.erase(exit)
	set_dungeon_data(Vector2i(exit.x, exit.y), RoomType.EXIT)


# Returns true if the passed position is within the bounds of the floor DIMENSIONS.
func _is_valid_position(position: Vector2i) -> bool:
	return (position.x >= 0 and position.x < DIMENSIONS.x and 
			position.y >= 0 and position.y < DIMENSIONS.y)
