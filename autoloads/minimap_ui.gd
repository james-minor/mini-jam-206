extends Control

var COLORS = [Color(255/255.0, 246/255.0, 211/255.0, 1),Color(255/255.0,246/255.0,211/255.0, 1),Color(124/255.0,63/255.0,88/255.0, 1),Color(235/255.0,107/255.0,111/255.0, 1),Color(249/255.0,168/255.0,117/255.0, 1)]

func _ready() -> void:
	MapState.set_room_active(PlayerTracker.current_room)
	var i: int = 0
	var children = self.get_children()
	for room in MapState.rooms:
		i += 1
		if room == MapState.RoomVisibility.EMPTY or room == MapState.RoomVisibility.UNSEEN:
			pass
		elif room == MapState.RoomVisibility.REVEALED:
			children[i].color = COLORS[MapState.RoomVisibility.REVEALED]
		elif room == MapState.RoomVisibility.ENTERED:
			children[i].color = COLORS[MapState.RoomVisibility.ENTERED]
		else:
			children[i].color = COLORS[MapState.RoomVisibility.ACTIVE]
