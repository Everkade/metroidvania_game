extends State
class_name PlayerMain

# get player
@onready var player: Player = $"../.."

var current_move := "idle"

func physics_update(delta):
	
	#region Animation
	var loc = "parameters/set_move/"
	
	# Get current move
	current_move = (
		"idle" if player.move == 0 else "run"
	)
	
	# Set current move type
	player.animation_tree[loc + "move/transition_request"] = current_move
	
	#endregion
	
	# Count Jump buffer
	if player.jump_buffer_count > 0:
		player.jump_buffer_count -= delta
	# Set Jump buffer
	if Con.player.jump.press and player.velocity.y >= 0:
		player.jump_buffer_count = player.jump_buffer_time
		
	# go to jump state
	if player.jump_buffer_count > 0 and player.coyote_count > 0:
		Transitioned.emit(self, "jump")
	
	Global.apply_gravity(player, delta)

# update state
func update(_delta):
	pass
	
