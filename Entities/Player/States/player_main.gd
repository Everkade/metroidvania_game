extends State
class_name PlayerMain

# get player
@onready var player: Player = $"../.."
@onready var animation_tree = player.get_node("AnimationTree")

func physics_update(delta):
	
	# Animation
	if player.direction != 0:
		# Start idle animation
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	else:
		# Start idle animation
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	
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
func update(delta):
	pass
	
