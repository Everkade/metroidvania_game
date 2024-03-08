extends State
class_name PlayerState

# get player
@onready var player: Player = $"../.."

var will_transition_into := {
	"jump": func(): return player.jump_buffer_count > 0 and player.coyote_count > 0, 
	"duck": func(): return (
		(Con.player.down.hold and player.is_on_floor())
		or not player.can_leave_duck
	),
	#"": func(): return 
}

# When an exlusive condition is set, all conditions in their list is flagged false
var exclusive_conditions := {
	"is_main": ["is_duck"],
	"is_duck": ["is_main"],
}

# This is used to define all the transition functions for the player (used by all the )
func check_transition_into(state_name):
	if will_transition_into.has(state_name):
		if will_transition_into[state_name].call():
			
			transition_to(state_name)
	else:
		print("Transition is not defined in player_state script! \n
			Please add check will_transition_into"
		)

func transition_to(state_name):
	#if is_duck_locked() and player.move_machine.current_state is PlayerDuck:
		#super.transition_to("duck")
	
	super.transition_to(state_name)

func animation_tree_set_condition(condition_name: String, _bool: bool):
	if player.animation_tree:
		# Prevent transition if we are locked in duck
		if is_duck_locked() and exclusive_conditions["is_duck"].has(condition_name): 
			if not player.move_machine.current_state is PlayerDuck:
				transition_to("duck") 
			return
		
		set_exclusive_condition(condition_name)
		player.animation_tree["parameters/conditions/" + condition_name] = _bool

func set_exclusive_condition(condition_name: String):
	if exclusive_conditions.has(condition_name):
		for condition in exclusive_conditions[condition_name]:
			player.animation_tree["parameters/conditions/" + condition] = false

func animation_tree_get_condition(condition_name: String):
	if player.animation_tree:
		return player.animation_tree["parameters/conditions/" + condition_name]
	return false

func is_duck_locked() -> bool:
	player.set_can_leave_duck_animation()
	return not player.can_leave_duck and animation_tree_get_condition("is_duck")
