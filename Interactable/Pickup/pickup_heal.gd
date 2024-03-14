extends Sprite2D



func _on_pickup_area_picked_up(player: Player):
	if player:
		player.health.heal(1)
	queue_free()
