extends AnimationPlayer

func _on_hitbox_take_damage() -> void:
	play("take_damage")
