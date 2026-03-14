class_name PlayerStateMoving
extends PlayerState

@export
var move_speed: float


func input_state(event: InputEvent) -> void:
	if event.is_action_pressed("move_down"):
		%PlayerSprite.animation = "move_down"
	if event.is_action_pressed("move_right"):
		%PlayerSprite.animation = "move_right"
	if event.is_action_pressed("move_up"):
		%PlayerSprite.animation = "move_up"
	if event.is_action_pressed("move_left"):
		%PlayerSprite.animation = "move_left"
	
	if event.is_action_pressed("lasso_pull_self"):
		print("Lassoing towards an object.")
		transition_to("dead")
	if event.is_action_pressed("lasso_pull_other"):
		%LassoHandler.lasso_to_object()
	
	if event.is_action_pressed("move_dash"):
		transition_to("dashing")


func physics_process_state(_delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector.is_zero_approx():
		%PlayerSprite.stop()
	else:
		%PlayerSprite.play()
	
	player.velocity = move_speed * input_vector
	player.move_and_slide()


func _on_death_collider_detector_body_entered(_body: Node2D) -> void:
	transition_to("dead")
