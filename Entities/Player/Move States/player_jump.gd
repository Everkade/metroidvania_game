extends PlayerState
class_name PlayerJump

# TODO add jump animation

var can_enter_twister := false

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
		
	if not Con.player.jump.hold:
		if player.can_leave_duck:
			transition_to_main()
		else:
			transition_to("duck")
		
	if player.velocity.y < 0 and player.jump_linear_count > 0:
		player.velocity.y = player.jump_power
	
	Global.apply_gravity(player, delta)

func exit():
	player.velocity.y *= player.jump_cancel_percent
	player.jump_linear_count = 0
	player.jump_buffer_count = 0
