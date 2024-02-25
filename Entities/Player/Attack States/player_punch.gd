extends State
class_name PlayerPunch

# get player
@onready var player: Player = $"../.."
var is_action_loc := "parameters/conditions/is_action"
var dir_loc = "parameters/set_action/punch_dir/transition_request"

func enter():
	# Lock direction when entering
	player.animation_tree[dir_loc] = Global.dir_name(player.direction)

func physics_update(delta):
	# Animation
	if player.attack_count > 0:
		player.attack_count -= delta
	else:
		Transitioned.emit(self, "action")
	
	player.animation_tree[is_action_loc] = false


func exit():
	player.animation_tree[is_action_loc] = false
