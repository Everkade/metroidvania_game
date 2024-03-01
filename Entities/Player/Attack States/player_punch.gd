extends State
class_name PlayerPunch

# get player
@onready var player: Player = $"../.."
# get hurt shape
@onready var punch_shape := $Hurtbox/CollisionShape2D

var is_action_loc := "parameters/conditions/is_action"
var dir_loc = "parameters/set_action/punch_dir/transition_request"

@export var attack_frames : 	int = 25
var attack_time := float(attack_frames) / 60
var attack_count : float = 0.0

@export var change_direction_frames : 	int = 3
var change_direction_time := float(3) / 60
var change_direction_count : float = 0.0

func enter():
	# Set grace frames for changing direction
	change_direction_count = change_direction_time
	
	# Set player combo count
	attack_count = attack_time

func physics_update(delta):
	print(player.action_buffer_count)
	if change_direction_count > 0:
		change_direction_count -= delta
	else:
		player.lock_direction = true
	
	# Animation
	if attack_count > 0:
		attack_count -= delta
	else:
		Transitioned.emit(self, "action")
	
	player.animation_tree[is_action_loc] = false
	
	punch_shape.position.x = player.direction * abs(punch_shape.position.x)


func exit():
	player.animation_tree[is_action_loc] = false
	player.lock_direction = false
