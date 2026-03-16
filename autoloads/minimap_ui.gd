extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MapState.set_room_active(PlayerTracker.current_room)
	var i: int = 1
	var children = self.get_children()
	for room in MapState.rooms:
		if room == MapState.RoomVisibility.EMPTY or room == MapState.RoomVisibility.EMPTY:
			continue
		if room == MapState.RoomVisibility.REVEALED:
			children[i].color = MapState.COLORS[MapState.RoomVisibility.REVEALED]
		elif room == MapState.RoomVisibility.ENTERED:
			children[i].color = MapState.COLORS[MapState.RoomVisibility.ENTERED]
		else:
			children[i].color = MapState.COLORS[MapState.RoomVisibility.ACTIVE]
