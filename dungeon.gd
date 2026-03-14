extends Node2D

@export var dimensions : Vector2i = Vector2i(10, 5)
@export var start : Vector2i = Vector2i(-1, -1)
@export var critical_path_length : int = 20
@export var branches : int = 4
@export var branch_length : Vector2i = Vector2i(1, 4)
var _branch_candidates : Array[Vector2i]
var _current_room : Vector2i
var _dungeon : Array


func _ready() -> void:
	# TODO: Clear dictionary on floor exit
	_initialize_dungeon()
	_place_entrance()
	_generate_critical_path(start, critical_path_length, "m")
	_generate_branch()
	_place_exit()
	_print_dungeon()

func _initialize_dungeon() -> void:
	for x in dimensions.x:
		_dungeon.append([])
		for y in dimensions.y:
			_dungeon[x].append(0)
			
func _print_dungeon() -> void:
	var dungeon_as_string : String = ""
	for y in range(dimensions.y - 1, -1, -1):
		for x in dimensions.x:
			dungeon_as_string += "[" + str(_dungeon[x][y]) + "]"
		dungeon_as_string += "\n"
	print(dungeon_as_string)

func _place_entrance() -> void:
	if start.x < 0 or start.x >= dimensions.x:
		start.x = randi_range(0, dimensions.x - 1)
	if start.y < 0 or start.y >= dimensions.y:
		start.y = randi_range(0, dimensions.y - 1)
	_dungeon[start.x][start.y] = "S"

func _place_exit() -> void:
	var exit = _branch_candidates[randi_range(0, _branch_candidates.size() - 1)]
	_branch_candidates.erase(exit)
	_dungeon[exit.x][exit.y] = "E"

func _generate_critical_path(current: Vector2i, length: int, room_type: String) -> bool:
	if (length == 0): 
		return true
	if current == null:
		current = start
		
	var direction : Vector2i
	match randi_range(0,3):
		0:
			direction = Vector2i.UP
		1:
			direction = Vector2i.RIGHT
		2:
			direction = Vector2i.DOWN
		3:
			direction = Vector2i.LEFT
	for i in 4:
		if (is_valid_pos(current + direction) and not _dungeon[current.x + direction.x][current.y + direction.y]):
			current += direction
			if length > 1:
				_dungeon[current.x][current.y] = room_type
			_branch_candidates.append(current)
			if _generate_critical_path(current, length - 1, room_type):
				return true
			else:
				_branch_candidates.erase(current)
				_dungeon[current.x][current.y] = 0
				current -= direction
		direction = Vector2(direction.y, -direction.x)
	return false
	
func _generate_branch() -> void:
	var branches_created : int = 0
	var candidate : Vector2i
	while branches_created < branches and _branch_candidates.size():
		candidate = _branch_candidates[randi_range(0, _branch_candidates.size() - 1)]
		if _generate_critical_path(candidate, randi_range(branch_length.x, branch_length.y), str(branches_created+1)):
			branches_created += 1
		else:
			_branch_candidates.erase(candidate)

func register_player():
	_current_room = start
	

func is_valid_pos(pos: Vector2i):
	return (pos.x >= 0 and pos.x < dimensions.x and 
			pos.y >= 0 and pos.y < dimensions.y)

func move_room(direction: Vector2i):
	var new_pos: Vector2i = _current_room + direction 
	if (is_valid_pos(new_pos) and _dungeon[new_pos.x][new_pos.y]):
		_current_room = new_pos

func get_current_room() -> Vector2i:
	return _current_room
	
func get_current_room_info():
	return get_room_info(_current_room)

func get_room_info(room: Vector2i):
	return _dungeon[room.x][room.y]
