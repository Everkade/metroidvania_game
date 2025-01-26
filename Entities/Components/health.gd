extends Node2D
class_name Health

var health := 0.0

@export var max_health : float = 3.0

# Health signals
signal TakeDamage
signal HasDied

func _ready():
	update_max_health()
	health = max_health

func hurtbox_damage(hurtbox: Hurtbox):
	damage(hurtbox.damage, hurtbox)
	
	if health <= 0:
		HasDied.emit()

func damage(damage_number : float, hurtbox = null):
	health -= damage_number
	TakeDamage.emit(damage_number, hurtbox)

func heal(amount: float):
	if health < max_health:
		health += amount
		
		if health > max_health:
			health = max_health

#region PLAYER SPECIFIC

@export var _upgrade : Upgrade

func update_max_health(change = null):
	if _upgrade:
		if typeof(change) == TYPE_INT:
			_upgrade.base_health_add += change
		max_health = _upgrade.base_health + _upgrade.base_health_add
	elif typeof(change) == TYPE_INT:
		max_health += change

#endregion
