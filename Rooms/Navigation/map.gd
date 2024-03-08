extends Node2D

@export_file("*.tscn") var room_start_node : String
@export_file("*.tscn") var room_player_node : String

# Player node that exists in Map tree
var player : Player
var simulate_duck := false

# Set from room_change.gd opun room change
var room_exit_direction : RoomChange.DIR = RoomChange.DIR.LEFT
# Set from Global.switch_scene method
var current_room : Room = null
var room_change_node_name : String = ""
# Used to check if we're actually moving to a new room
var old_room_name := ""

func _ready():
	pass

# Used to start the map world from the selected start room
func load_map():
	
	# Create player
	player = load(room_player_node).instantiate()
	add_child(player)
	
	# Create room
	current_room = load(room_start_node).instantiate()
	# Add the current room to the map
	Map.add_child(current_room)
	
	Global.current_scene = current_room
	
# Switch scene for room
func switch_room(room_resource: String, room_change_name = ""):
	simulate_duck = player and player.move_machine.current_state is PlayerDuck
	
	Con.reset_inputs()
	Con.similate_mode = true
	# Start simulating run
	var is_horzontal = [RoomChange.DIR.LEFT, RoomChange.DIR.RIGHT].has(room_exit_direction)
	
	if is_horzontal:
		if room_exit_direction == RoomChange.DIR.LEFT:
			Con.player.left.hold = true
		else:
			Con.player.right.hold = true
	else:
		# vertical transitions
		pass
		
	if simulate_duck:
		Con.player.down.hold = true
	
	var fade = load("res://FX/transition_fade.tscn").instantiate()
	get_tree().root.add_child(fade)
	# Start the fade in animation
	fade.transition("in")
	# Connect the Ended signal of transition to _on_room_transition_out_ended
	fade.Ended.connect(
		_on_room_transition_out_ended.bind(
			room_resource, room_change_name, 
			fade
		)
	)
	
func _on_room_transition_out_ended(
	room_resource: String, room_change_name = "",
	fade = null,
):
	Con.reset_inputs()
	Con.similate_mode = false
	
	# Fade out
	if fade:
		fade.queue_free()
	fade = load("res://FX/transition_fade.tscn").instantiate()
	get_tree().root.add_child(fade)
	# Start the fade out animation
	fade.transition("out")
	# Connect the Ended signal of transition to _on_room_transition_in_ended
	fade.Ended.connect(
		_on_room_transition_in_ended.bind(fade)
	)
	
	# Set the target name for the linked room change
	room_change_node_name = room_change_name
	
	old_room_name = current_room.get_name()
	Global.switch_scene(room_resource)

func _on_room_transition_in_ended(fade):
	fade.queue_free()
