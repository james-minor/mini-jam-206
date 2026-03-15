class_name PlayerStateHoldingEnemy
extends PlayerState

@export
var throw_power: float

var held_enemy: Enemy

@onready
var _hold_timer: Timer = Timer.new()


func _ready() -> void:
	_hold_timer.one_shot = true
	_hold_timer.timeout.connect(_on_hold_timer_timeout)
	add_child(_hold_timer)


func on_enter_state() -> void:
	%LassoLine.visible = true
	_hold_timer.start(1)


func input_state(event: InputEvent) -> void:
	if event.is_action_pressed("lasso"):
		if held_enemy.global_position.distance_to(player.global_position) > 15:
			print("too far to throw")
			return
		
		held_enemy.throw(player.global_position.direction_to(player.get_global_mouse_position()), throw_power)
		transition_to("moving")


func process_state(delta: float) -> void:
	if held_enemy.global_position.distance_to(player.global_position) < 15:
		%ThrowIndicator.visible = true
		_hold_timer.stop()
	
	%LassoLine.target_position = held_enemy.global_position


func _on_hold_timer_timeout() -> void:
	if held_enemy.global_position.distance_to(player.global_position) > 15:
		held_enemy.throw(Vector2.ZERO, 0)
		transition_to("moving")


func on_exit_state() -> void:
	%ThrowIndicator.visible = false
	%LassoLine.visible = false
