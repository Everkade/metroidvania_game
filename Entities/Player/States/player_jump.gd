extends State
class_name PlayerJump

# get player
@onready var player: Player = $"../.."

func enter():
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
		Transitioned.emit(self, "main")
	
	Global.apply_gravity(player, delta)

func exit():
	player.jump_linear_count = 0
	player.jump_buffer_count = 0
