extends Control

func _process(delta: float) -> void:
	%TimerLabel.text = str(_timer_float_to_string(RunTimer.get_time()))


func _timer_float_to_string(value: float) -> String:
	return "%02d : %02d" % [value / 60, int(value) % 60]
