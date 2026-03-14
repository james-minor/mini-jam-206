extends TileMapLayer

## Time between generation of pit tiles.
@export
var time_between_pit_creation: float

## How long a tile marked for destruction will take to turn into a pit.
@export
var time_for_tile_break: float

# Internal timer to track if the tilemap should create a pit tile.
var _pit_timer: float = 0.0

# Queue of what tile coordinates to convert into a pit. 
@onready
var _destruction_queue: Array[Vector2i] = []




func _physics_process(delta: float) -> void:
	_pit_timer += delta
	
	if _pit_timer >= time_between_pit_creation:
		_pit_timer = 0
		_generate_pit_tile()


func _generate_pit_tile() -> void:
	var cell_coords: Array[Vector2i] = get_used_cells()
	var tiles_checked: int = 0
	
	while tiles_checked < cell_coords.size():
		var index = randi_range(0, cell_coords.size() - 1)
		
		# Checking if tile can be converted into a pit.
		if get_cell_tile_data(cell_coords[index]).get_custom_data_by_layer_id(0) as bool:
			set_cell(cell_coords[index], 1, Vector2i(0, 4))
			_destruction_queue.push_back(cell_coords[index])
			
			var collapse_timer: Timer = Timer.new()
			collapse_timer.autostart = true
			collapse_timer.wait_time = time_for_tile_break
			collapse_timer.timeout.connect(_on_collapse_timer_timeout)
			add_child(collapse_timer)
			
			return
		
		tiles_checked += 1


func _on_collapse_timer_timeout() -> void:
	get_child(0).queue_free()
	
	if _destruction_queue.size() > 0:
		set_cells_terrain_connect([_destruction_queue.pop_front()], 0, 0)
