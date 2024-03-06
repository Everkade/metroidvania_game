extends PlayerState
class_name PlayerJump


func enter():
	print("jump!")
	player.jump_linear_count = player.jump_linear_time
	player.velocity.y = player.jump_power

func physics_update(delta):
	# Animation
	#...
	# Jump count
	if player.jump_linear_count > 0:
		player.jump_linear_count -= delta
		
	if Con.player.jump.hold and player.velocity.y < 0:
		if player.jump_linear_count > 0:
			player.velocity.y = player.jump_power
	else:
		player.velocity.y *= player.jump_cancel_percent
		transition_to_main()
	
	Global.apply_gravity(player, delta)

func exit():
	player.jump_linear_count = 0
	player.jump_buffer_count = 0
