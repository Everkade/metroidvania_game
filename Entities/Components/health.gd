extends Node2D
class_name Health

var health := 0.0

@export var max_health : float = 6
@export var use_stats : bool = false

@onready var _stats : Stats = (
	null if not use_stats else
	get_node("../Stats")
)

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

func update_max_health(change = null):
	if _stats:
		if typeof(change) == TYPE_INT:
			_stats.max_health_add += change
		max_health = _stats.max_health + _stats.max_health_add
	elif typeof(change) == TYPE_INT:
		max_health += change
