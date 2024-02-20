extends Area2D
class_name RoomChange

enum DIR {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

@export var room_exit_direction : DIR
@export_file("*.tscn") var room_change_scene : String

func _ready():
	pass

# Player switch
func _process(delta):
	for body in get_overlapping_bodies():
		if body is Player:
			try_to_switch_rooms(body)
			break

		
func try_to_switch_rooms(player: Player):
	if is_room_exit_direction(player.velocity):
		Global.switch_room(room_change_scene, self.get_name())
		

func is_room_exit_direction(velocity: Vector2) -> bool:
	var will_exit_room = false
	
	var room_exit_x = (
		-1 if room_exit_direction == DIR.LEFT
		else 1 if room_exit_direction == DIR.RIGHT
		else 0
	)
	var room_exit_y = (
		-1 if room_exit_direction == DIR.UP
		else 1 if room_exit_direction == DIR.DOWN
		else 0
	)
	
	will_exit_room = (
		( room_exit_x != 0 and room_exit_x == sign(velocity.x) ) or 
		( room_exit_y != 0 and room_exit_y == sign(velocity.y) )
	)
	
	Global.room_exit_direction = (
		-1 if not will_exit_room 
		else room_exit_direction
	)
	
	return will_exit_room

