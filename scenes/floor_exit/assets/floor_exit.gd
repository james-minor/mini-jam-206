extends Node2D


func _ready() -> void:
	if DungeonGenerator.get_room_type(PlayerTracker.current_room) != DungeonGenerator.RoomType.EXIT:
		visible = false
		%PlayerMonitor.monitoring = false


func _on_player_monitor_body_entered(body: Node2D) -> void:
	print("WOAH")
	
	if not body is Player:
		return
	
	DungeonGenerator.generate_floor()
	await DungeonGenerator.generation_complete
	PlayerTracker.current_floor += 1
	SceneChanger.change_scene(DungeonGenerator.get_room_file(PlayerTracker.current_room))
