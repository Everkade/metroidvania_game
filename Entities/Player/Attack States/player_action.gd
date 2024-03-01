extends State
class_name PlayerAction

# get player
@onready var player: Player = $"../.."
var is_action_loc := "parameters/conditions/is_action"

var action_list = [
	"hold",
	"throw",
	"punch" 
]
var current_action := "punch"

func enter():
	pass
	
func physics_update(delta):
	
	# Count action buffer
	if player.action_buffer_count > 0:
		player.action_buffer_count -= delta
	
	# Actions are buffered from player scripta
	if player.action_buffer_count > 0:
		# Cancel the buffer
		player.action_buffer_count = 0.0
		# If current action is a valid action
		if action_list.has(current_action):
			player.animation_tree[is_action_loc] = true
			# Transition to the action state
			transition_to_action(current_action)
		else:
			# NO ACTION TO DO!!
			pass


func transition_to_action(action_name: String):
	var action_loc = "parameters/set_action/action/transition_request"
	player.animation_tree[action_loc] = current_action
	
	match action_name:
		"punch":
			# Transition into punch
			Transitioned.emit(self, "punch")
		"hold":
			pass
		"throw":
			pass
