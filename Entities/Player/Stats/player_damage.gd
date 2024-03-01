extends Node2D

@export var damage : float = 3

#TODO change hitbox direction
func _on_hurtbox_body_entered(body):
	print(body)
	
	for child in body.get_children():
		print("dolor")
		if child is EnemyHealth:
			child.hit(damage)
	print(body.name)
