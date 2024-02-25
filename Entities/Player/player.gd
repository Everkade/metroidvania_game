extends Entity
class_name Player

# The direction the player is trying to move in (with left right controls)
var direction : int = 0
# The collision info that happens to the player every _physics_process
var collision : KinematicCollision2D = get_slide_collision(0)
# The last step position of the player (used to compare with the current position)
var last_position := Vector2(0.0, 0.0)

# max speed player accelerates to while running
@export var run_speed: 		float = 200

@export var acceleration: 	float = 3000
@export var traction : 		float = 2000
@export var friction : 		float = 200

@export var air_control_percent : float = 0.75

var air_accel : float = acceleration * air_control_percent
var air_traction : float = traction * air_control_percent
var air_friction : float = friction * air_control_percent

@export var jump_power := -250.0
@export var jump_cancel_percent := 0.5

@export var jump_linear_frames : 	int = 14
@export var jump_buffer_frames : 	int = 10
@export var coyote_frames : 		int = 7

@export var attack_frames : 	int = 40

var jump_linear_time := float(jump_linear_frames) / 60
var jump_buffer_time := float(jump_buffer_frames) / 60
var coyote_time := float(coyote_frames) / 60

var jump_buffer_count : float = 0.0
var jump_linear_count : float = 0.0
var coyote_count : float = 0.0

var attack_time := float(attack_frames) / 60
var attack_count : float = 0.0

@onready var animation_tree : AnimationTree = $AnimationTree

# Global signals, used by health_bar
signal player_take_damage(damage_amount: float)
signal player_set_max_health(max_health: float)

@onready var _health: Health = $Health

func _ready():
	# Set slip margin
	#Global.set_slip_margin(self, $CollisionShape2D)
	animation_tree.active = true
	
	# Update HUD Health bar with max health
	SignalMgr.register_publisher(self, "player_take_damage")
	SignalMgr.register_publisher(self, "player_set_max_health")
	player_set_max_health.emit(_health.max_health)

func _physics_process(delta):
	# Direction sign
	direction = int(Con.player.right.hold) - int(Con.player.left.hold)
	
	# Sprite flip
	if direction != 0:
		$Sprite2D.flip_h = true if direction == -1 else false
	
	Global.run_move(self, direction, run_speed, delta)
	
	# Get last position to compare after we move
	last_position = position
	# Move player
	var did_collide = move_and_slide()
	# Get collision info
	#collision = get_slide_collision(0)
	# Do something on collide?
	if did_collide:
		pass
	
	# Set velocity 0 if no change in x (this gives 0 when moving into wall)
	if position.x == last_position.x:
		velocity.x = 0
	# Set velocity 0 if no change in y (this gives 0 when moving into floor/ceiling)
	if position.y == last_position.y:
		velocity.y = 0 
	
	#print(velocity)
	
	# Coyote time
	if(is_on_floor()):
		coyote_count = coyote_time
	elif coyote_count > 0:
		coyote_count -= delta


func _on_health_damage_health(damage: float) -> void:
	if damage: player_take_damage.emit(damage)
