extends PlayerState
class_name PlayerAction

var action_list = [
	"hold",
	"throw",
	"punch" 
]
var current_action := "punch"

func enter():
	animation_tree_set_condition("is_action", false)
	
func physics_update(_delta):
	
	# Actions are buffered from player script
	if player.action_buffer_count > 0:
		# Cancel the buffer
		player.action_buffer_count = 0.0
		# If current action is a valid action
		if action_list.has(current_action):
			# Transition to the action state
			transition_to_action(current_action)
		else:
			# NO ACTION TO DO!!
			pass


func transition_to_action(action_name: String):
	
	animation_tree_set_condition("is_action", true)
	var action_loc = "parameters/set_action/action/transition_request"
	player.animation_tree[action_loc] = current_action
	
	match action_name:
		"punch":
			# Transition into punch
			transition_to("punch")
		"hold":
			pass
		"throw":
			pass
