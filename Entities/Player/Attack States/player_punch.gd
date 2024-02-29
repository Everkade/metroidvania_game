extends State
class_name PlayerPunch

# get player
@onready var player: Player = $"../.."
var is_action_loc := "parameters/conditions/is_action"
var dir_loc = "parameters/set_action/punch_dir/transition_request"

@export var attack_frames : 	int = 25
var attack_time := float(attack_frames) / 60
var attack_count : float = 0.0

func enter():
	player.lock_direction = true
	# Set player combo count
	attack_count = attack_time

func physics_update(delta):
	# Animation
	if attack_count > 0:
		attack_count -= delta
	else:
		Transitioned.emit(self, "action")
	
	player.animation_tree[is_action_loc] = false


func exit():
	player.animation_tree[is_action_loc] = false
	player.lock_direction = false
