extends PlayerState
class_name PlayerJump

# TODO add jump animation

func enter():
	player.jump_linear_count = player.jump_linear_time
	player.velocity.y = player.jump_power

func physics_update(delta):
	
	# Animation
	player.set_can_leave_duck_animation()
	if player.can_leave_duck:
		animation_tree_set_condition("is_main", true)
		player.cancel_duck_state()
	
	# Jump count
	if player.jump_linear_count > 0:
		player.jump_linear_count -= delta
		
	if Con.player.jump.hold and player.velocity.y < 0:
		if player.jump_linear_count > 0:
			player.velocity.y = player.jump_power
	else:
		player.velocity.y *= player.jump_cancel_percent
		
		if player.can_leave_duck:
			transition_to_main()
		else:
			transition_to("duck")
	
	Global.apply_gravity(player, delta)

func exit():
	player.jump_linear_count = 0
	player.jump_buffer_count = 0
