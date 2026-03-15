extends EnemyState


var movement_speed: float = 20.0
@onready var navigation_agent: NavigationAgent2D = %NavigationAgent2D


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 2.0
	set_movement_target(GlobalVariables.player_position)
	

func on_enter_state() -> void:
	%EnemySprite.play()


func physics_process_state(_delta):
	if navigation_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = enemy.global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	enemy.velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	if abs(enemy.velocity.x) > abs(enemy.velocity.y):
		if enemy.velocity.x < 0:
			%EnemySprite.animation = "move_left"
		elif enemy.velocity.x > 0:
			%EnemySprite.animation = "move_right"
	else:
		if enemy.velocity.y > 0:
			%EnemySprite.animation = "move_down"
		elif enemy.velocity.y < 0:
			%EnemySprite.animation = "move_up"

	enemy.move_and_slide()


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func _on_death_collider_detector_body_entered(_body: Node2D) -> void:
	print("Enemy hit death collider")
	transition_to("dead")


func _on_timer_timeout() -> void:
	set_movement_target(GlobalVariables.player_position)
