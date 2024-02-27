extends Node2D

# export to set initial state
@export var attack_initial_state : AttackState

var attack_current_state : AttackState
var attack_states : Dictionary = {}

func _ready():
	# Loop through child nodes of state machine
	for child in get_children():
		# If State is found in state machine
		if child is AttackState:
			# Add state to states dictionary
			attack_states[child.name.to_lower()] = child
			# Connect new states to the transitioned signal, calling state transition
			child.attack_Transitioned.connect(on_state_transition)
	# if initial state is set, enter into that state
	print(attack_states)
	if attack_initial_state:
		attack_initial_state.enter()
		attack_current_state = attack_initial_state

func _process(delta):
	if attack_current_state:
		attack_current_state.update(delta)
	
func _physics_process(delta):
	if attack_current_state:
		attack_current_state.physics_update(delta)
		
func on_state_transition(attack_state, attack_new_state_name):
	# return if state is not current_state
	if attack_state != attack_current_state:
		return
	
	# grab new state from states dictionary
	var attack_new_state = attack_states.get(attack_new_state_name.to_lower())
	# return if new state does not exist
	if !attack_new_state:
		return
	
	if attack_current_state:
		# call the current state exit func if there is one
		attack_current_state.exit()
		
	# call enter func of the new state
	attack_new_state.enter()
	# set the current_state to the new_state
	attack_current_state = attack_new_state
