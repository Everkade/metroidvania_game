extends Node2D
class_name Health

@export var max_health : float = 6
var health : float

signal TakeDamage
signal HasDied

func _ready():
	health = max_health

func damage(hurtbox: Hurtbox):
	
	health -= hurtbox.damage
	print("HP: " + str(health))
	
	TakeDamage.emit(hurtbox.damage)
	
	if health <= 0:
		HasDied.emit()
		
func heal(amount: float):
	if health < max_health:
		health += amount
		
		if health > max_health:
			health = max_health

		
#func heal(amount: float):
	#if health < max_health:
		#health += amount
		#
		#if health > max_health:
			#health = max_health
