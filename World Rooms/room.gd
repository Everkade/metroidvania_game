extends Area2D
class_name Room

func _ready():
	# Check if no room change node
	if Global.room_change_node_name == "":
		# Do something? 
		pass
	#If no player than we need to find a room change
	elif get_node(Global.room_change_node_name):
		var room_change = get_node(Global.room_change_node_name)
		
		var player = (
			$Player if $Player 
			else load("res://Entities/Player/player.tscn").instantiate()
		)
		add_child(player)
		
		var rc_box = room_change.get_child(0)
		var rc_height = rc_box.shape.size.y
		player.position.x = rc_box.position.x
		player.position.y = rc_box.position.y + rc_height / 2
