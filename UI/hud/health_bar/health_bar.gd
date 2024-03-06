extends HBoxContainer

const HEART = preload("res://UI/hud/health_bar/heart.tscn")
var _current_health : float
var _max_health: float


func _ready() -> void:
	SignalMgr.register_subscriber(self, "PlayerTakeDamage")
	SignalMgr.register_subscriber(self, "PlayerSetMaxHealth")


func _on_PlayerTakeDamage(damage_amount: float):
	for i in damage_amount:
		var heart = _get_last_heart()
		
		# End function early if no full hearts are available
		if !heart: return
		
		heart.empty_heart()
		_current_health -= 1


func _on_PlayerSetMaxHealth(max_health: float):
	# TODO We can only set the max health once for now. Maybe revisit if we want health upgrades
	if _max_health > 0: return
	_max_health = max_health
	_current_health = _max_health
	
	for i in max_health:
		var heart = HEART.instantiate()
		add_child(heart)

# Get the rightmost full heart
func _get_last_heart():
	var index = _current_health - 1
	
	if index < 0:
		return null
	
	# Will not work if there are non-heart children in the HealthBar
	return get_child(index)
