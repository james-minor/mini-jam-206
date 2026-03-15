extends Node

var _time: float = 0

var _is_running: bool = false

func _physics_process(delta: float) -> void:
	if _is_running:
		_time += delta

func _ready() -> void:
	start()

## Starts the run timer.
func start() -> void:
	_is_running = true


## Stops the run timer.
func stop() -> void:
	_is_running = false


## Returns the run timer.
func get_time() -> float:
	return _time

func get_time_string() -> String:
	return "%02d : %02d" % [_time / 60, int(_time) % 60]
