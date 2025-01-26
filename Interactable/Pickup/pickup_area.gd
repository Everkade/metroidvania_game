extends Area2D
class_name PickupArea

signal PickedUp(body: Player)

func _on_body_entered(body):
	if body is Player:
		PickedUp.emit(body)
