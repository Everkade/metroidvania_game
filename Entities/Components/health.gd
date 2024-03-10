extends Node2D
class_name Health

var health := 0.0

@export var max_health : float = 3.0
@export var use_upgrade : bool = false

# Health signals
signal TakeDamage
signal HasDied

func _ready():
	update_max_health()
	health = max_health

func damage(hurtbox: Hurtbox):
	health -= hurtbox.damage
	
	TakeDamage.emit(hurtbox)
	
	if health <= 0:
		HasDied.emit()

func heal(amount: float):
	if health < max_health:
		health += amount
		
		if health > max_health:
			health = max_health

#region PLAYER SPECIFIC

@onready var _upgrade : Upgrade = get_node("../Upgrade")

func update_max_health(change = null):
	if _upgrade:
		if typeof(change) == TYPE_INT:
			_upgrade.base_health_add += change
		max_health = _upgrade.base_health + _upgrade.base_health_add
	elif typeof(change) == TYPE_INT:
		max_health += change

#endregion
