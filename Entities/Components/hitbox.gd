extends Area2D
class_name Hitbox

@export var health: Health

func damage(attack: Attack):
	# if hitbox has a health component
	if health:
		# pass the attack into the damage func of health
		health.damage(attack)
