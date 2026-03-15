extends Control

func _process(_delta: float) -> void:
	%TimerLabel.text = RunTimer.get_time_string()
