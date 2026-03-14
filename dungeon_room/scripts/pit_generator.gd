extends TileMapLayer

## Time between generation of pit tiles.
@export
var time_between_pit_creation: float = 2

# Internal timer to track if the tilemap should create a pit tile.
var _pit_timer: float = 0.0


func _physics_process(delta: float) -> void:
	_pit_timer += delta
	
	if _pit_timer >= time_between_pit_creation:
		_pit_timer = 0
		_generate_pit_tile()


func _generate_pit_tile() -> void:
	var cell_coords: Array[Vector2i] = get_used_cells()
	var pit_generated: bool = false
	var tiles_checked: int = 0
	
	while not pit_generated and tiles_checked < cell_coords.size():
		var index = randi_range(0, cell_coords.size() - 1)
		
		# Checking if tile can be converted into a pit.
		if get_cell_tile_data(cell_coords[index]).get_custom_data_by_layer_id(0) as bool:
			set_cells_terrain_connect([cell_coords[index]], 0, 0)
			pit_generated = true
		
		tiles_checked += 1
