extends Ability
class_name AbilityTwister

@export var power := -250.0
@export var linear_frames : int = 10
@export var float_frames : int = 120

var linear_time := float(linear_frames) / 60
var linear_count := 0.0

var float_time := float(float_frames) / 60
var float_count := 0.0

@export var float_speed := 40.0
