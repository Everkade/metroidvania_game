extends State
class_name PlayerState

# get player
@onready var player: Player = $"../.."

var will_transition_into := {
	"jump": func(): return player.jump_buffer_count > 0 and player.coyote_count > 0, 
	"duck": func(): return Con.player.down.hold,
	#"": func(): return 
}

# This is used to define all the transition functions for the player (used by all the )
func check_transition_into(state_name):
	if will_transition_into.has(state_name):
		if will_transition_into[state_name].call():
			if state_name == "jump":
				print("jump!")
			Transitioned.emit(self, state_name)
	else:
		print("Transition is not defined in player_state script! \n
			Please add check will_transition_into"
		)


func animation_tree_set_condition(condition_name: String, _bool: bool):
	if player.animation_tree:
		player.animation_tree["parameters/conditions/" + condition_name] = _bool


func animation_tree_get_condition(condition_name: String):
	if player.animation_tree:
		return player.animation_tree["parameters/conditions/" + condition_name]
	return false
