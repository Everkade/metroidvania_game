extends State
class_name PlayerMain

# get player
@onready var player: Player = $"../.."

func physics_update(delta):
	Global.apply_gravity(player, delta)

# update state
func update(delta):
	
	# Start idle animation
	player.get_node("AnimatedSprite2D").play("idle")
	
	# Count Jump buffer
	if player.jump_buffer_count > 0:
		player.jump_buffer_count -= delta
	# Set Jump buffer
	if Con.player.jump.press and player.velocity.y >= 0:
		player.jump_buffer_count = player.jump_buffer_time
		
	# go to jump state
	if player.jump_buffer_count > 0 and player.coyote_count > 0:
		Transitioned.emit(self, "jump")
		
