class_name StateMachine
extends Node
## General purpose hierarchical finite-state machine. Handles transitioning between
## states, allows for hierarchical grouping of states using the SceneTree. Must have
## children which extend from [State].
##
## To externally set the current State, call the [code]set_state[/code] function.
## Note that state names are internally handled in lowercase and are therefore
## case-independent. E.g., the state names [code]NEW_STATE[/code] and
## [code]new_state[/code] both internally evaluate to the same state object.
##
## For more information see the [State] class documentation.

## Emitted when the current state is changed.
signal state_changed

## The initial state of the state machine upon entering the SceneTree.
@export 
var initial_state: State

# Array that contains the currently loaded state and parents. The front index [0]
# will always be the currently loaded state, and the back index [size - 1] will 
# be the root state of the currently loaded state.
#
# E.g. Loading State3 in the following tree:
# - State1
#  - State2
#   - State3
#  - State4
# 
# Will result in the array: [State3, State2, State1]
var _current_state_stack: Array[State] = []

# Dictionary of all states that this finite-state machine can access.
var _states: Dictionary[String, State] = {}


func _ready() -> void:
	_states = _get_all_states_recursive(self)
	
	# Setting the initial state.
	if not initial_state and len(_states) > 0:
		push_warning('No initial state set, using first State in state array')
		_current_state_stack = _build_state_stack_array(_states.values()[0])
		set_state(_states.keys()[0])
	else:
		_current_state_stack = _build_state_stack_array(initial_state)
		set_state(initial_state.name.to_lower())
	
	for state in _current_state_stack:
		state.on_enter_state()


# Bubbling the engine input to the current state input.
func _input(event: InputEvent) -> void:
	for state in _current_state_stack:
		state.input_state(event)


# Bubbling the engine physics process to the current state physics process.
func _physics_process(delta: float) -> void:
	for state in _current_state_stack:
		state.physics_process_state(delta)


# Bubbling the engine process to the current state hierarchy processes.
func _process(delta: float) -> void:
	for state in _current_state_stack:
		state.process_state(delta)


# Handler function that is called when the FSM is transitioning from one state
# to another.
func _on_state_transition(old_state: State, new_state_key: String) -> void:
	# Ignoring transitions from states that are not the current state.
	if old_state != get_state():
		return
	
	# Fetching the new state object.
	var new_state: State = _states.get(new_state_key.to_lower())
	if !new_state:
		push_warning('Could not find State `%s` in StateMachine' % new_state_key.to_lower())
		return
	
	var exit_states = _get_states_to_exit_from(new_state)
	var enter_states = _get_states_to_enter_into(new_state)
	
	# Processing state exits from leaf -> root.
	for state in exit_states:
		state.on_exit_state()
	
	_current_state_stack = _build_state_stack_array(new_state)
	
	# Processing state enters from root -> leaf.
	for i in range(enter_states.size() - 1, -1, -1):
		enter_states[i].on_enter_state()
	
	state_changed.emit()


# Returns the stack array for a target state node.
func _build_state_stack_array(target_state: State) -> Array[State]:
	var output: Array[State] = []
	var pointer: State = target_state
	while pointer.get_parent() != self:
		output.push_back(pointer)
		pointer = pointer.get_parent() 
	
	output.push_back(pointer)
	return output


# Recursively gets all available states for this state machine.
func _get_all_states_recursive(target_node: Variant) -> Dictionary[String, State]:
	var states: Dictionary[String, State] = {}
	
	for child in target_node.get_children():
		if child is State:
			child._transition.connect(_on_state_transition)
			states[child.name.to_lower()] = child
			states.merge(_get_all_states_recursive(child))
	
	return states


# Returns the array of states we need to exit from to get to the target state hierarchy.
func _get_states_to_exit_from(target_state: State) -> Array[State]:
	var exit_states: Array[State] = []
	for state in _current_state_stack:
		if not _build_state_stack_array(target_state).has(state):
			exit_states.push_back(state)
	
	return exit_states


# Returns the array of states we need to enter into to get to the target state hierarchy.
func _get_states_to_enter_into(target_state: State) -> Array[State]:
	var enter_states: Array[State] = []
	for state in _build_state_stack_array(target_state):
		if not _current_state_stack.has(state):
			enter_states.push_back(state)
	
	return enter_states


## Sets the current state of the FSM.
func set_state(key: String) -> void:
	assert(_states.has(key.to_lower()), "StateMachine does not contain a state with the name %s" % key.to_lower())
	_on_state_transition(_current_state_stack.front(), key.to_lower())


## Returns the current state of the FSM.
func get_state() -> State:
	return _current_state_stack.front()
