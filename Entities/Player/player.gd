extends Entity
class_name Player

# max speed player accelerates to while running
@export var run_speed: 		float = 200

@export var acceleration: 	float = 3000
@export var traction : 		float = 2000
@export var friction : 		float = 200

@export var air_control_percent : float = 0.75

var air_accel : float = acceleration * air_control_percent
var air_traction : float = traction * air_control_percent
var air_friction : float = friction * air_control_percent

@export var jump_power := -250.0
@export var jump_cancel_percent := 0.5

@export var jump_linear_frames : 	int = 14
@export var jump_buffer_frames : 	int = 10
@export var coyote_frames : 		int = 6

var jump_linear_time := float(jump_linear_frames) / 60
var jump_buffer_time := float(jump_buffer_frames) / 60
var coyote_time := float(coyote_frames) / 60

var jump_buffer_count : float = 0.0
var jump_linear_count : float = 0.0
var coyote_count : float = 0.0

# When ready, get control enum
@onready var control_mode = Con.MODE

var position_float_x : float = 0.0
var position_float_y : float = 0.0

var direction: int = 0


func _ready():
	Global.set_slip_margin(self, $Hitbox)


func _physics_process(delta):
	# Direction sign
	direction = int(Con.player.right.hold) - int(Con.player.left.hold)
	
	Global.run_move(self, direction, run_speed, delta)
	
	if Input.is_action_just_pressed("ui_text_backspace"):
		if Con.mode == control_mode.PLAYER:
			Con.set_control_mode(control_mode.MENU)
		else:
			Con.set_control_mode(control_mode.PLAYER)	
	
	move_and_slide()
	
	# Coyote time
	if(is_on_floor()):
		coyote_count = coyote_time
	elif coyote_count > 0:
		coyote_count -= delta
