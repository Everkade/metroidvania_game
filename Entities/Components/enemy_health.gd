extends Node2D
class_name EnemyHealth

@export var max_health : float = 6
var health : float


func _ready():
	health = max_health 

func hit(damage: int):
	health -= damage
	
	if health <= 0:
		get_parent().queue_free()
		
#func heal(amount: float):
	#if health < max_health:
		#health += amount
		#
		#if health > max_health:
			#health = max_health
