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
	
	"left": key_press.duplicate(),
	"right": key_press.duplicate(),
	"up": key_press.duplicate(),
	"down": key_press.duplicate(),
}

# Control enum defines mode that informs our control dictionaries to update or not 
enum CON_MODE {
	NONE,
	MENU,
	PLAYER
}
@export var mode : CON_MODE = CON_MODE.MENU
# to reference our control dictionaries by mode enum
var control_types : Array = [ none, menu, player ]

func set_control_mode(new_mode: CON_MODE):
	# set current control dictionary to false
	var control_dict = control_types[mode]
	for control in control_dict:
		control_dict[control].press = false
		control_dict[control].hold = false
		control_dict[control].released = false
	# set new control mode
	mode = new_mode

func update_control_mode():
	# set current control dictionary to false
	var control_dict = control_types[mode]
	for control in control_dict:
		control_dict[control].press = Input.is_action_just_pressed(control)
		control_dict[control].hold = Input.is_action_pressed(control)
		control_dict[control].released = Input.is_action_just_released(control)

func _ready():
	pass

func _process(delta):
	update_control_mode()
