extends Entity
class_name Enemy

@export var base_speed := 40.0
@export var acceleration: 	float = 3000
@export var friction : 		float = 1000
@export var air_control_percent : float = 1.0

@export var delay_destroy_count : float = 0.2
var start_destroy := false

@onready var hurtbox : Hurtbox = $Hurtbox
@onready var direction : int = 1 if facing == DIR.RIGHT else -1
@onready var move := direction

func _on_health_has_died():
	start_destroy = true


func _on_health_take_damage(_damage_number, _hurtbox: Hurtbox):
	if _hurtbox:
		velocity = _hurtbox.knockback_velocity


func _process(delta):
	if delay_destroy_count <= 0:
		queue_free()
	
	if start_destroy:
		if hurtbox:
			hurtbox.monitoring = false
		delay_destroy_count -= delta


func play_animation(animation_name: String, animation_scale := 1.0):
	var _animation_player = $AnimationPlayer
	if _animation_player:
		_animation_player.play(animation_name, -1, animation_scale)
