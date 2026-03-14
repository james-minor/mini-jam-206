extends Node2D

@export var _dimensions : Vector2i = Vector2i(10, 5)
@export var _start : Vector2i = Vector2i(-1, -1)
@export var _critical_path_length : int = 20
@export var _branches : int = 4
@export var _branch_length : Vector2i = Vector2i(1, 4)
var _branch_candidates : Array[Vector2i]
var _player_room : Vector2i
var dungeon : Array

func _ready() -> void:
	_initialize_dungeon()
	_place_entrance()
	_generate_critical_path(_start, _critical_path_length, "m")
	_generate_branch()
	_place_exit()
	_print_dungeon()

func _initialize_dungeon() -> void:
	for x in _dimensions.x:
		dungeon.append([])
		for y in _dimensions.y:
			dungeon[x].append(0)
			
func _print_dungeon() -> void:
	var dungeon_as_string : String = ""
	for y in range(_dimensions.y - 1, -1, -1):
		for x in _dimensions.x:
			dungeon_as_string += "[" + str(dungeon[x][y]) + "]"
		dungeon_as_string += "\n"
	print(dungeon_as_string)

func _place_entrance() -> void:
	if _start.x < 0 or _start.x >= _dimensions.x:
		_start.x = randi_range(0, _dimensions.x - 1)
	if _start.y < 0 or _start.y >= _dimensions.y:
		_start.y = randi_range(0, _dimensions.y - 1)
	dungeon[_start.x][_start.y] = "S"

func _place_exit() -> void:
	var exit = _branch_candidates[randi_range(0, _branch_candidates.size() - 1)]
	_branch_candidates.erase(exit)
	dungeon[exit.x][exit.y] = "E"

func _generate_critical_path(current: Vector2i, length: int, room_type: String) -> bool:
	if (length == 0): 
		return true
	if current == null:
		current = _start
		
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
		if (current.x + direction.x >= 0 and current.x + direction.x < _dimensions.x and
			current.y + direction.y >= 0 and current.y + direction.y < _dimensions.y and 
			not dungeon[current.x + direction.x][current.y + direction.y]):
			current += direction
			if length > 1:
				dungeon[current.x][current.y] = room_type
			_branch_candidates.append(current)
			if _generate_critical_path(current, length - 1, room_type):
				return true
			else:
				_branch_candidates.erase(current)
				dungeon[current.x][current.y] = 0
				current -= direction
		direction = Vector2(direction.y, -direction.x)
	return false
	
func _generate_branch() -> void:
	var branches_created : int = 0
	var candidate : Vector2i
	while branches_created < _branches and _branch_candidates.size():
		candidate = _branch_candidates[randi_range(0, _branch_candidates.size() - 1)]
		if _generate_critical_path(candidate, randi_range(_branch_length.x, _branch_length.y), str(branches_created+1)):
			branches_created += 1
		else:
			_branch_candidates.erase(candidate)

func _register_player():
	_player_room = _start

func _get_current_room_info():
	return get_room_info(_player_room)

func _get_room_info(room: Vector2i):
	pass
