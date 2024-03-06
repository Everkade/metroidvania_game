extends PlayerState
class_name PlayerMain

var current_move := "idle"

func enter():
	animation_tree_set_condition("is_main", true)

func physics_update(delta):
	
	#region Animation
	var loc = "parameters/set_main/"
	
	# Get current move
	current_move = (
		"idle" if player.move == 0 else "run"
	)
	
	# Set current move type
	player.animation_tree[loc + "move/transition_request"] = current_move
	
	#endregion
	
	check_transition_into("jump")
	check_transition_into("duck")
	
	Global.apply_gravity(player, delta)


# update state
func update(_delta):
	pass


func exit():
	animation_tree_set_condition("is_main", false)
