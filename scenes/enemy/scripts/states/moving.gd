extends EnemyState


var movement_speed: float = 30.0
@onready var navigation_agent: NavigationAgent2D = %NavigationAgent2D


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 2.0
	navigation_agent.target_desired_distance = 2.0
	navigation_agent.debug_enabled = true
	set_movement_target(GlobalVariables.player_position)
	

func _physics_process(_delta):
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


func input_state(event: InputEvent) -> void:
	if not event.is_action_pressed("lasso_pull_self"):
		return
	var mouse_pos = enemy.get_local_mouse_position()# I hate this
	var clickbox:Rect2 = %ClickBox2.get_shape().get_rect()
	clickbox.position += enemy.position
	print("Enemy clickbox rooted at %v with size %v" % [clickbox.position, clickbox.size])
	if clickbox.has_point(mouse_pos):
		print("Enemy selected")
	else:
		print("Player at pos %v. Click at %v" % [GlobalVariables.player_position, mouse_pos])
	if GlobalVariables.player_position.distance_to(enemy.global_position) <= GlobalVariables.max_lasso_length:
		print("Enemy within range")

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func _on_death_collider_detector_body_entered(body: Node2D) -> void:
	transition_to("dead")


func _on_timer_timeout() -> void:
	set_movement_target(GlobalVariables.player_position)
