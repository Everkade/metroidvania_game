extends Area2D
class_name Hurtbox

@export var damage : float = 1
@export var knockback : float = 1

# For contantly attacking player
var damage_player_hitbox : Hitbox

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		area.damage(self)
		
		# Start constant attack on player hitbox
		if area is PlayerHitbox:
			damage_player_hitbox = area

func _process(_delta):
	# Continue attack on player if vulnerable
	if damage_player_hitbox:
		damage_player_hitbox.damage(self)

# Cancel attack on player
func _on_area_exited(area):
	if damage_player_hitbox and area is PlayerHitbox:
		damage_player_hitbox = null
