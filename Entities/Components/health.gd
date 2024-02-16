extends Node2D
class_name Health

@export var max_health : float = 6
var health : float

func _ready():
	health = max_health 

func damage(attack: Attack):
	health -= attack.damage
	
	if health <= 0:
		get_parent().queue_free()
		
func heal(amount: float):
	if health < max_health:
		health += amount
		if health > max_health:
			health = max_health
