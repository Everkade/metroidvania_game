extends Area2D
class_name Hurtbox

@export var attack: EnemyAttack

func _on_area_entered(area: Area2D) -> void:
	if attack and area is Hitbox:
		area.damage(attack)
