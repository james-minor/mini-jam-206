@abstract
class_name State
extends Node
## Abstract class intended to act as an interface for States, used in 
## conjunction with the [StateMachine] class.

# Signal emitted when the state wants to transition to another state. 
signal _transition(old_state: State, new_state: String)

## Called once when the State is entered.
func on_enter_state() -> void:
	pass

## Called once when the State is exited.
func on_exit_state() -> void:
	pass

## Called once every frame when the state is active.
@warning_ignore("unused_parameter")
func process_state(delta: float) -> void:
	pass

## Called once every physics tick when the state is active.
@warning_ignore("unused_parameter")
func physics_process_state(delta: float) -> void:
	pass

## Called for every InputEvent when the state is active.
@warning_ignore("unused_parameter")
func input_state(event: InputEvent) -> void:
	pass

## Signals to the parent [StateMachine] object that the state wants to transition
## out of itself into a different state.
func transition_to(state: String) -> void:
	_transition.emit(self, state)
