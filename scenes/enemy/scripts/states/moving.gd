extends EnemyState

@export
var bullet_scene: PackedScene

var movement_speed: float = 20.0
@onready var navigation_agent: NavigationAgent2D = %NavigationAgent2D

@onready
var fire_timer: Timer = Timer.new()

func _ready():
	fire_timer.wait_time = randf_range(2.2, 4.0)
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 2.0
	set_movement_target(GlobalVariables.player_position)
	

func on_enter_state() -> void:
	%EnemySprite.play()
	fire_timer.start()


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


func on_exit_state() -> void:
	fire_timer.stop()


func _on_death_collider_detector_body_entered(_body: Node2D) -> void:
	print("Enemy hit death collider")
	transition_to("dead")


func _on_timer_timeout() -> void:
	set_movement_target(GlobalVariables.player_position)


func _on_fire_timer_timeout() -> void:
	var bullet: EnemyBullet = bullet_scene.instantiate() as EnemyBullet
	bullet.global_position = enemy.global_position
	bullet.set_target_position(GlobalVariables.player_position)
	get_tree().root.add_child(bullet)
