extends Entity
class_name Enemy

func _on_health_has_died():
	queue_free()
