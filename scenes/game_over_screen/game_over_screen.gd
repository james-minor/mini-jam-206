extends Control


func _ready() -> void:
	%TimeLabel.text = "Time: %s" % [RunTimer.get_time_string()]
	%FloorLabel.text = "Floor: %d / 5" % [PlayerTracker.current_floor]


func _on_new_run_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
