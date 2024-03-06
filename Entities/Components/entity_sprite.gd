extends Sprite2D
class_name EntitySprite

# For modulating the color to white on hit!
@export var hit_blend_factor := 10.0
@export var hit_blend_frames := 15

var blend_factor := 1.0
var follow_blend_factor := 1.0
var hit_blend_time := hit_blend_frames / 60.0
var hit_blend_speed := 2*hit_blend_factor / hit_blend_time

func _process(delta):
	blend_factor = Global.approach(blend_factor,
		follow_blend_factor, hit_blend_speed, 
		delta
	)
	
	if follow_blend_factor >= 1 and blend_factor == follow_blend_factor:
		follow_blend_factor = 1
	
	modulate.r = blend_factor
	modulate.g = blend_factor
	modulate.b = blend_factor
	
