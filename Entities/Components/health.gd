extends Node2D
class_name Health

@export var max_health : float = 6
var health : float

# TODO either need a heal signal, or consolidate damage and heal together
# Consolidating would require damage to be a negative value here and in health_bar
signal damage_health(damage: float)

func _ready():
	health = max_health 

func damage(attack: Attack):
	health -= attack.damage
	
	damage_health.emit(attack.damage)
	
	if health <= 0:
		get_parent().queue_free()
		
func heal(amount: float):
	if health < max_health:
		health += amount
		
		if health > max_health:
			health = max_health
