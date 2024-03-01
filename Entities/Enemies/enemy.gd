extends Entity
class_name Enemy

func _on_enemy_death():
	queue_free()
