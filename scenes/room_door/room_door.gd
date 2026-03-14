class_name DungeonRoomDoor
extends Node2D

signal player_entered()

@export
var direction: Vector2i = Vector2i.UP


func _ready() -> void:
	match direction:
		Vector2i.UP:
			%DoorSprite.rotation_degrees = 0
		Vector2i.RIGHT:
			%DoorSprite.rotation_degrees = 90
		Vector2i.DOWN:
			%DoorSprite.rotation_degrees = 180
		Vector2i.LEFT:
			%DoorSprite.rotation_degrees = 270


func disable() -> void:
	%DoorSprite.region_rect.position.x = 16
	%PlayerMonitor.monitoring = false


func enable() -> void:
	%DoorSprite.region_rect.position.x = 0
	%PlayerMonitor.monitoring = true


func _on_player_monitor_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	player_entered.emit()
	
	PlayerTracker.entering_direction = direction
	
	PlayerTracker.current_room += direction
	var new_room_packed_scene: PackedScene = DungeonGenerator.get_room_file(PlayerTracker.current_room)
	
	
	get_tree().call_deferred("change_scene_to_packed", new_room_packed_scene)
