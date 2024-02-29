extends Area2D
class_name Hitbox

@onready var entity : CharacterBody2D = $".."
@export var health: Health
@export var time_between_damage: float

@export var alpha_flash_length := 0.125
var alpha := 1.0
var alpha_flash := 0.0
var alpha_flash_follow := 0.0

@export var damage_cooldown_timer: Timer
@onready var _damage_cooldown_timer := time_between_damage
var invulnerable := false

signal TakeDamage

func damage(attack: Attack):
	# Exit now if the hitbox is not ready to take damage
	if damage_cooldown_timer and !damage_cooldown_timer.is_stopped(): return
	
	# Reset values
	alpha_flash = 0.0
	alpha_flash_follow = 0.0
	if entity is Player:
		entity.invulnerable = false
	
	# Temporary invulnerability
	# _time_between_damage should match the duration of the animation player's animation
	if _damage_cooldown_timer: damage_cooldown_timer.start(_damage_cooldown_timer)
		
	# if hitbox has a health component
	if health:
		# pass the attack into the damage func of health
		# TODO could probably make the signal take attack param, and trigger health damage by signal
		# TODO this would mean that health is not passed to hitbox, but hitbox is passed to health instead
		health.damage(attack)
		TakeDamage.emit()
		if entity is Player:
			entity.invulnerable = true
