extends AttackState
class_name AttackMain

# get player
@onready var player: Player = $"../.."

func physics_update(delta):

	if Con.player.action.press:
		player.attack_count = player.attack_time
		
	if player.attack_count > 0:
		attack_Transitioned.emit(self, "punch")
		

# update state
func update(delta):
	pass
	

