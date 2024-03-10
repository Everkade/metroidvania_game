extends PlayerState
class_name PlayerTwister

var phase := "start"

func enter():
	player.twister.can_use = false
	phase = "start"
	player.twister.linear_count = player.twister.linear_time
	player.velocity.y = player.twister.power

func physics_update(delta):
	
	match phase:
		"start":
			# Twister count
			if player.twister.linear_count > 0:
				player.twister.linear_count -= delta
				
			if not Con.player.jump.hold:
				transition_to_main()
				
			if player.velocity.y < 0:
				if player.twister.linear_count > 0: 
					player.velocity.y = player.twister.power
			else:
				player.twister.float_count = player.twister.float_time
				phase = "float"
			
			Global.apply_gravity(player, delta)
		"float":
			# Float count
			if player.twister.float_count > 0:
				player.twister.float_count -= delta
			
			if Con.player.jump.hold and player.twister.float_count > 0:
				player.velocity.y = player.twister.float_speed
			else:
				transition_to_main()

func exit():
	player.velocity.y *= player.jump_cancel_percent
