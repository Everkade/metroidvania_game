extends Area2D
class_name Room

# On new room:
func _ready():
	
	# Get player if player of make player
	var player = (
		$Player if $Player 
		else load("res://Entities/Player/player.tscn").instantiate()
	)
	
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
	
	# Check if no room change node
	if Global.room_change_node_name == "":
		# Do something? 
		pass
	#If no player than we need to find a room change
	elif get_node(Global.room_change_node_name):
		
		add_child(player)
		
		var room_change = get_node(Global.room_change_node_name)
		var rc_box = room_change.get_child(0)
		var rc_height = rc_box.shape.size.y
		player.position.x = rc_box.position.x
		player.position.y = rc_box.position.y + rc_height / 2
