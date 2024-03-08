extends PlayerState
class_name PlayerPunch

# get hurt shape
@onready var punch_up : Hurtbox = $UpHurtbox
@onready var punch_side : Hurtbox = $SideHurtbox
@onready var punch_duck : Hurtbox = $DuckHurtbox

var is_action_loc := "parameters/conditions/is_action"
# informs the punch animation to be used
var punch_type := "side"

@export var attack_frames : 	int = 25
var attack_time := float(attack_frames) / 60
var attack_count : float = 0.0

@export var change_direction_frames : 	int = 3
var change_direction_time := float(3) / 60
var change_direction_count : float = 0.0

func enter():
	punch_up.refresh_ignore()
	punch_side.refresh_ignore()
	punch_duck.refresh_ignore()
	
	# Set initial punch animation (this can be updated in a short time window)
	punch_type = "side"
	set_punch_type_animation()
	
	# Set grace frames for changing direction
	change_direction_count = change_direction_time
	
	# Set player combo count
	attack_count = attack_time


func physics_update(delta):
	if change_direction_count > 0:
		change_direction_count -= delta
		# Update direction grace count
		set_punch_type_animation()
	else:
		player.lock_direction = true
	
	if animation_tree_get_condition("is_duck"):
		update_punch_type()
	
	update_punch_direction()
	
	if attack_count > 0:
		attack_count -= delta
	else:
		Transitioned.emit(self, "action")
	
	player.animation_tree[is_action_loc] = false

func update_punch_direction():
	var _dir = player.direction
	var _hurtbox_dir = (
		Hurtbox.DIR.RIGHT if _dir == 1 
		else Hurtbox.DIR.LEFT
	)
	
	punch_side.get_child(0).position.x = _dir * abs(punch_side.get_child(0).position.x)
	punch_side.knockback_direction = _hurtbox_dir
	
	punch_duck.get_child(0).position.x = _dir * abs(punch_duck.get_child(0).position.x)
	punch_duck.knockback_direction = _hurtbox_dir

func set_punch_type_animation():
	
	if animation_tree_get_condition("is_duck"):
		punch_type = "duck"
	elif Con.player.up.hold:
		punch_type = "up"
	
	update_punch_type()

func update_punch_type():
	if punch_type == "side":
		disable_up_hurtbox()
		disable_duck_hurtbox()
	
	if punch_type == "duck":
		disable_side_hurtbox()
		disable_up_hurtbox()
	
	if punch_type == "up":
		disable_side_hurtbox()
		disable_duck_hurtbox()
	
	var punch_type_loc = "parameters/set_action/punch_type/transition_request"
	player.animation_tree[punch_type_loc] = punch_type

func disable_side_hurtbox():
	punch_side.monitoring = false
	punch_side.get_child(0).visible = false
	
func disable_up_hurtbox():
	punch_up.monitoring = false
	punch_up.get_child(0).visible = false

func disable_duck_hurtbox():
	punch_duck.monitoring = false
	punch_duck.get_child(0).visible = false

func exit():
	player.animation_tree[is_action_loc] = false
	player.lock_direction = false
