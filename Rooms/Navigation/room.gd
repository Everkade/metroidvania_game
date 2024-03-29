extends Area2D
class_name Room

var spawn_pos := Vector2(0, 0)

# On new room:
func _ready():
	
	# Set current Map room
	Map.current_room = self
	if Map.old_room_name == get_name():
		# Self warp! therefore set wrong warp spawn
		Map.room_change_node_name = ""
	
	# Get player from Map
	var player = Map.player
	
	if $Spawn:
		spawn_pos = $Spawn.position
	
	# Check if no room change node name set
	if Map.room_change_node_name == "":
		# Do something? 
		pass
	# If we find a room change node of the same name in the room then we update player spawn
	elif get_node(Map.room_change_node_name):
		
		var room_change = get_node(Map.room_change_node_name)
		var rc_box = room_change.get_child(0)
		var rc_height = rc_box.shape.size.y
		
		var is_horzontal = [RoomChange.DIR.LEFT, RoomChange.DIR.RIGHT].has(
			Map.room_exit_direction
		)
		if is_horzontal:
			spawn_pos.x = rc_box.position.x
			spawn_pos.y = rc_box.position.y + rc_height / 2
		else:
			spawn_pos.x = rc_box.position.x
			spawn_pos.y = rc_box.position.y
		
	player.position = spawn_pos
	
	# Set camera borders
	var camera = player.get_node("Camera")
	
	var border_w = $Border.shape.size.x
	var border_h = $Border.shape.size.y
	
	var left = $Border.position.x - border_w / 2
	var right = $Border.position.x + border_w / 2
	var top = $Border.position.y - border_h / 2
	var bottom = $Border.position.y + border_h / 2
	
	camera.limit_left = left
	camera.limit_right = right
	camera.limit_top = top
	camera.limit_bottom = bottom
