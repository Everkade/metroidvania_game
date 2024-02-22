extends State
class_name PlayerAttack

# get player
@onready var player: Player = $"../.."

func enter():
	print("hi")

func physics_update(delta):
	
	# Animation
	#...
	print("attack")
	
	if player.attack_count > 0:
		player.attack_count -= delta
	else:		
		Transitioned.emit(self, "main")
	

func exit():
	print("exit")
	player.attack_count = 0
