extends Control

# We duplicate this dictionary to each key press entry in our control mode doctionaries
var key_press : Dictionary = { "press": false, "hold": false, "released": false }

# Used to prevent any control from user
var none := {}

# Menu control dictionary (READ for MENU CONTROL)
var menu := {
	"confirm": key_press.duplicate(),
	"cancel": key_press.duplicate(),
	
	"left": key_press.duplicate(),
	"right": key_press.duplicate(),
	"up": key_press.duplicate(),
	"down": key_press.duplicate(),
} 

# Player control dictrionary (READ for PLAYER CONTROL)
var player := {
	"jump": key_press.duplicate(),
	"action": key_press.duplicate(),
	
	"left": key_press.duplicate(),
	"right": key_press.duplicate(),
	"up": key_press.duplicate(),
	"down": key_press.duplicate(),
	
}

# Control enum defines mode that informs our control dictionaries to update or not 
enum MODE {
	NONE,
	MENU,
	PLAYER
}
@export var mode : MODE = MODE.MENU
# to reference our control dictionaries by mode enum
var control_types : Array = [ none, menu, player ]

# In this mode, no inputs are read, use this to simulate controls
var similate_mode := false

func reset_inputs() -> Dictionary:
	# set current control dictionary to false
	var control_dict = control_types[mode]
	for control in control_dict:
		control_dict[control].press = false
		control_dict[control].hold = false
		control_dict[control].released = false
	return control_dict

func set_control_mode(new_mode: MODE):
	# set current control dictionary to false
	reset_inputs()
	# set new control mode
	mode = new_mode
	
	
func update_control_mode() -> void:
	if similate_mode:
		return
	# set current control dictionary to false
	var control_dict = control_types[mode]
	for control in control_dict:
		control_dict[control].press = Input.is_action_just_pressed(control)
		control_dict[control].hold = Input.is_action_pressed(control)
		control_dict[control].released = Input.is_action_just_released(control)

func _ready():
	pass

func _process(_delta):
	update_control_mode()
