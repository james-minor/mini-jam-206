extends Node
## Handles transitioning scenes when traveling between rooms.

## Speed of the screen transition fade-in/fade-out (in seconds).
@export_range(0, 5.0, 0.1, "suffix: seconds")
var transition_speed: float = 1.0

# Internal progress of the screen transition - 1.0 is fully black, 0.0 is fully transparent.
var _transition_progress: float = 0.0


func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)


func _on_scene_changed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "_transition_progress", 0.0, transition_speed)


func _process(_delta: float) -> void:
	%TransitionRect.material.set("shader_parameter/progress", _transition_progress)


func _on_fade_out(target: PackedScene) -> void:
	get_tree().call_deferred("unload_current_scene")
	get_tree().call_deferred("change_scene_to_packed", target)


## Changes to a target scene.
func change_scene(target: PackedScene) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "_transition_progress", 1.0, transition_speed)
	tween.tween_callback(_on_fade_out.bind(target))
