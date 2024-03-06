extends EntitySprite

@onready var player : Player = $".."

@export var alpha_flash_time := 0.125
@export var alpha_flash_minimum := 0.3

var alpha_flash_speed := (1.0 - alpha_flash_minimum) / alpha_flash_time

var alpha_flash := alpha_flash_minimum
var alpha_flash_follow := 1.0

func _process(delta):
	# EntitySprite _process
	super._process(delta)
	
	if player.invulnerable:
		
		alpha_flash = Global.approach(
			alpha_flash, alpha_flash_follow, 
			alpha_flash_speed, delta
		)
		modulate.a = alpha_flash
		
		if alpha_flash == alpha_flash_follow:
			alpha_flash_follow = update_follow_alpha()


func reset_invulnerable_visual():
	# Reset values
	alpha_flash = alpha_flash_minimum
	alpha_flash_follow = 1.0


func update_follow_alpha():
	if alpha_flash_follow == alpha_flash_minimum:
		return 1.0
	else:
		return alpha_flash_minimum
