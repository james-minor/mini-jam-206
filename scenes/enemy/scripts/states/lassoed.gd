extends EnemyState


var moving_to_player: bool
var launch_allowed: bool
@onready
var prev_position: Vector2 = enemy.position
var launch_velocity: Vector2 = Vector2(0,0)

func on_enter_state() -> void:
	moving_to_player = true
	launch_allowed = false


func physics_process_state(delta: float) -> void:
	if moving_to_player:
		enemy.velocity = enemy.position.direction_to(GlobalVariables.player_position) * 3 / delta
		enemy.move_and_slide()
		
	if prev_position == enemy.position and moving_to_player:
		moving_to_player = false
		launch_allowed = true
		print("At player. Allowing launch")
	else:
		prev_position = enemy.position


func process_state(delta: float) -> void:
	launch_velocity = (enemy.position - prev_position) / delta


func input_state(event: InputEvent) -> void:
	if event.is_action_pressed("lasso_pull_other") and launch_allowed:
		print("Launching enemy away...")
		launch_allowed = false
		var mouse_pos = enemy.get_global_mouse_position()
		var direction = enemy.global_position.direction_to(mouse_pos)
		var speed = clamp(mouse_pos.distance_to(enemy.global_position), -50, 50) + 100
		enemy.velocity = speed * direction
		transition_to("thrown")
