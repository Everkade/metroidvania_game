extends Enemy

@export var walk_speed = 40.0

@onready var direction : int = 1 if facing == DIR.RIGHT else -1
@onready var move := direction

@export var acceleration: 	float = 3000
@export var friction : 		float = 200
@export var air_control_percent : float = 0.75

func _ready():
	$AnimationPlayer.play("walk", -1, 1.75)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		Global.apply_gravity(self, delta)
	
	# Shown direction
	if move != 0:
		direction = move
	
	# Sprite flip
	$Sprite2D.flip_h = true if direction == -1 else false
	
	Global.physics_move(self, move, walk_speed, delta)

	move_and_slide()
	
	if is_on_wall():
		move *= -1 


func _on_health_has_died():
	_on_enemy_death()
