extends Sprite2D

@onready var player : Player = $".."
@onready var hitbox := $"../Hitbox"

func _process(delta):
	if hitbox and player.invulnerable:
		
		if hitbox.alpha_flash_follow == 0.0:
			hitbox.alpha_flash_follow = hitbox.alpha_flash_length
		elif hitbox.alpha_flash_follow == hitbox.alpha_flash_length:
			hitbox.alpha_flash_follow = 0.0
		hitbox.alpha_flash = Global.approach(
			hitbox.alpha_flash, hitbox.alpha_flash_follow, 
			hitbox.alpha_flash_length, delta
		)
		modulate.a = 1.0 - 0.5*(hitbox.alpha_flash / hitbox.alpha_flash_length)
		
		print(modulate.a)
