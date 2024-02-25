extends Node2D
class_name StateMachine

# export to set initial state
@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	# Loop through child nodes of state machine
	for child in get_children():
		# If State is found in state machine
		if child is State:
			# Add state to states dictionary
			states[child.name.to_lower()] = child
			# Connect new states to the transitioned signal, calling state transition
			child.Transitioned.connect(on_state_transition)
	# if initial state is set, enter into that state
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
		
func on_state_transition(state, new_state_name):
	# return if state is not current_state
	if state != current_state:
		return
	
	# grab new state from states dictionary
	var new_state = states.get(new_state_name.to_lower())
	# return if new state does not exist
	if !new_state:
		return
	
	if current_state:
		# call the current state exit func if there is one
		current_state.exit()
		
	# call enter func of the new state
	new_state.enter()
	# set the current_state to the new_state
	current_state = new_state
