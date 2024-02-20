extends Panel

@onready var sprite_2d: Sprite2D = $Sprite2D
const EMPTY_HEART = preload("res://Art/heart_empty.png")

func empty_heart():
	sprite_2d.texture = EMPTY_HEART
