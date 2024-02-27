extends Sprite2D

@onready var hitbox := $"../Hitbox"

func _process(_delta):
	if hitbox:
		modulate.a = hitbox.alpha
