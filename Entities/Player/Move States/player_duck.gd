extends PlayerState
class_name PlayerDuck


func enter():
	animation_tree_set_condition("is_duck", true)
	

func physics_update(delta):
	check_transition_into("jump")
	
	if not Con.player.down.hold:
		transition_to_main()
	
	Global.apply_gravity(player, delta)
	
func exit():
	animation_tree_set_condition("is_duck", false)

