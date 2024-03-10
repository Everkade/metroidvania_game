extends Entity
class_name Player

# The collision info that happens to the player every _physics_process
@onready var collision : KinematicCollision2D = null
# The last step position of the player (used to properly set real velocity)
var last_position := Vector2(0.0, 0.0)

#region MOVEMENT

@onready var move_machine : StateMachine = $MoveMachine

@onready var direction : int = 1 if facing == DIR.RIGHT else -1
# The direction the player is trying to move in (with left right controls)
var move := 0
# Either -1 or 1, only updated when move != 0
var lock_direction := false

# max speed player accelerates to while running
@export var run_speed: 		float = 200

#region DUCKING

@export var duck_speed_factor := 0.75
var duck_speed_factor_active := 1.0

# In some cases, we cannot cancel duck state
var can_leave_duck := true
@onready var leave_duck_area : Area2D = get_node("MoveMachine/Duck/LeaveCheck")

func set_can_leave_duck_animation():
	if leave_duck_area:
		can_leave_duck = not leave_duck_area.has_overlapping_bodies()
	
func cancel_duck_state():
	duck_speed_factor_active = 1.0

#endregion

@export var acceleration: 	float = 3000
@export var traction : 		float = 2000
@export var friction : 		float = 200
@export var air_control_percent : float = 0.75
#endregion

#region JUMPING

@export var jump_power := -250.0
@export var jump_cancel_percent := 0.5

@export var jump_linear_frames : 	int = 14
@export var jump_buffer_frames : 	int = 10
@export var coyote_frames : 		int = 7

var jump_linear_time := float(jump_linear_frames) / 60
var jump_buffer_time := float(jump_buffer_frames) / 60
var coyote_time := float(coyote_frames) / 60

var jump_buffer_count : float = 0.0
var jump_linear_count : float = 0.0
var coyote_count : float = 0.0
#endregion

#endregion

#region STATS: HEALTH, DAMAGE, INVULN...

@export var damage_invulnerable_time := 0.5
var damage_invulnerable_count := 0.0

# Global signals, used by health_bar
signal PlayerTakeDamage(damage_amount: float)

@onready var health : Health = $Health
signal PlayerSetMaxHealth(max_health: float)
#endregion

#region ACTIONS

@export var action_buffer_frames : int = 15

var action_buffer_time := float(action_buffer_frames) / 60
var action_buffer_count : float = 0.0

#endregion

#region UPGRADES
@onready var upgrade : Upgrade = $Upgrade
@export var twister : AbilityTwister

# Animation
@onready var animation_tree : AnimationTree = $Sprite2D/AnimationTree

func _ready():
	# Set slip margin
	Global.set_slip_margin(self, $CollisionShape2D)
	Global.set_slip_margin(self, $DuckShape2D)
	
	animation_tree.active = true
	
	# Sprite flip
	$Sprite2D.flip_h = true if direction == -1 else false
	
	# Update HUD Health bar with max health
	SignalMgr.register_publisher(self, "PlayerTakeDamage")
	SignalMgr.register_publisher(self, "PlayerSetMaxHealth")
	PlayerSetMaxHealth.emit(health.max_health)


func _physics_process(delta):
	# Move direction
	move = int(Con.player.right.hold) - int(Con.player.left.hold)
	
	# Shown direction
	if move != 0 and not lock_direction:
		direction = move
	
	# Sprite flip
	$Sprite2D.flip_h = true if direction == -1 else false
	
	Global.player_move_x(self, move, run_speed, duck_speed_factor_active, delta)
	
	# Get last position to compare after we move
	last_position = position
	# Move player
	var did_collide = move_and_slide()
	# Get collision info
	if get_slide_collision_count() > 0:
		collision = get_slide_collision(0)
	# Do something on collide?
	if did_collide:
		pass
	
	# Set velocity 0 if no change in x (this gives 0 when moving into wall)
	if position.x == last_position.x:
		velocity.x = 0
	# Set velocity 0 if no change in y (this gives 0 when moving into floor/ceiling)
	if position.y == last_position.y:
		velocity.y = 0 
	
	# Count action buffer
	if action_buffer_count > 0:
		action_buffer_count -= delta
	# Action buffer
	if Con.player.action.press:
		action_buffer_count = action_buffer_time
	
	# Coyote time
	if(is_on_floor()):
		twister.can_use = true
		coyote_count = coyote_time
	elif coyote_count > 0:
		coyote_count -= delta
	
	# Count Jump buffer
	if jump_buffer_count > 0:
		jump_buffer_count -= delta
	# Set Jump buffer
	if Con.player.jump.press:
		jump_buffer_count = jump_buffer_time
	
	# Invulnerable time
	if damage_invulnerable_count > 0:
		damage_invulnerable_count -= delta
	elif invulnerable:
		invulnerable = false
		$Sprite2D.modulate.a = 1.0

func _on_health_take_damage(hurtbox: Hurtbox):
	velocity = hurtbox.knockback_velocity
	
	if hurtbox: 
		PlayerTakeDamage.emit(hurtbox.damage)
		# Set invulnerable time
		invulnerable = true
		damage_invulnerable_count = damage_invulnerable_time
		$Sprite2D.reset_invulnerable_visual()

# Death sequence
func _on_health_has_died():
	print("PLAYER DIED!")
	# Replace with function body.
