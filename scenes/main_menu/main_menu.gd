extends Control

func _on_start_button_pressed() -> void:
	seed(%SeedInput.text.hash())
	DungeonGenerator.generate_floor()
