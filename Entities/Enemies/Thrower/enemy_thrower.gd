extends Enemy

@onready var aggro_range: Area2D = $AggroRange
@onready var shooter: Node2D = $Shooter

@onready var sprite := $Sprite2D
var walk_speed := base_speed

func _ready():
	move = 0
	pass
	#play_animation("walk", 1.75)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		Global.apply_gravity(self, delta)
	
	# Shown direction
	if move != 0:
		direction = move
	
	# Sprite flip
	sprite.flip_h = true if direction == -1 else false
	
	var _move_direction = move * walk_speed
	Global.physics_move_x(self, _move_direction, 1.0, delta)

	move_and_slide()
	
	if is_on_wall():
		move *= -1


func _on_aggro_range_body_entered(body):
	if body is Player:
		shooter.target = body


func _on_aggro_range_body_exited(body):
	if body is Player:
		shooter.target = null
