extends Area2D
class_name Hitbox

@export var health: Health
@onready var entity := $".."

func damage(hurtbox: Hurtbox):
	# if hitbox has a health component
	if health:
		# leave script if entity is flagged as invulnerable
		if entity and entity is Entity and entity.invulnerable: return
		
		# pass the attack into the damage func of health
		# TODO could probably make the signal take attack param, and trigger health damage by signal
		# TODO this would mean that health is not passed to hitbox, but hitbox is passed to health instead
		health.hurtbox_damage(hurtbox)
