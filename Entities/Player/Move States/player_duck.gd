extends PlayerState
class_name PlayerDuck


func enter():
	player.duck_speed_factor_active = player.duck_speed_factor
	animation_tree_set_condition("is_duck", true)
	
func physics_update(delta):
	
	# Before we try to leave duck we must check if we can
	player.set_can_leave_duck_animation()
	
	# jumping can happen when ducking is locked but operates differently
	check_transition_into("jump")
	
	if player.can_leave_duck:
		if not Con.player.down.hold:
			transition_to_main()
	
	Global.apply_gravity(player, delta)
	
func exit():
	# When we leave, we only cancel the duck if not locked in
	if player.can_leave_duck:
		player.cancel_duck_state()
		
