extends PlayerState
class_name PlayerMain

var current_move := "idle"

func enter():
	animation_tree_set_condition("is_main", true)

func physics_update(delta):

	#region Animation
	if animation_tree_get_condition("is_main"):
		# Get current move
		current_move = (
			"idle" if player.move == 0 else "run"
		)
		animation_tree_main_transition(current_move)

	#endregion
	
	check_transition_into("jump")
	check_transition_into("twister")
	check_transition_into("duck")
	
	Global.apply_gravity(player, delta)


# update state
func update(_delta):
	pass
