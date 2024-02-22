extends Area2D
class_name Hitbox

@export var health: Health
@export var time_between_damage: float
@export var take_damage_cooldown: Timer

@onready var _time_between_damage := time_between_damage

signal take_damage

func damage(attack: Attack):
	# Exit now if the hitbox is not ready to take damage
	if take_damage_cooldown and !take_damage_cooldown.is_stopped(): return
	
	# Temporary invulnerability
	if _time_between_damage: take_damage_cooldown.start(_time_between_damage)
		
	# if hitbox has a health component
	if health:
		# pass the attack into the damage func of health
		# TODO could probably make the signal take attack param, and trigger health damage by signal
		# TODO this would mean that health is not passed to hitbox, but hitbox is passed to health instead
		health.damage(attack)
		take_damage.emit()
