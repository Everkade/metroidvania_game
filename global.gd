extends Node

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

# Global helper data and variables
enum LAYER {
	INTERACT,
	ENEMY,
	PLAYER,
	WALLS
}

func approach(start_val, end_val, spd, delta = 1) -> float:
	var new_val = start_val
	if start_val < end_val:
		new_val = start_val + spd * delta
		new_val = clamp(new_val, start_val, end_val)
	elif start_val > end_val:
		new_val = start_val - spd * delta
		new_val = clamp(new_val, end_val, start_val)
	return new_val

func dir_name(direction: int) -> String:
	if direction == -1: return "left"
	return "right"

func set_slip_margin(entity: Entity, hitbox: CollisionShape2D):
	if entity and hitbox:
		var slip_margin = 0.001
		if entity is CharacterBody2D:
			slip_margin = entity.safe_margin
		
		if hitbox.shape is RectangleShape2D:
			# This will set a slip margin for the box allowing for 16 px boxes to slip into 16 px spaces
			hitbox.shape.size.x -= slip_margin*2
			hitbox.shape.size.y -= slip_margin*2
		elif hitbox.shape is CapsuleShape2D:
			hitbox.shape.radius -= slip_margin*2
			hitbox.shape.height -= slip_margin*2
		elif hitbox.shape is CircleShape2D:
			hitbox.shape.radius -= slip_margin*2

#region PLATFORMING PHYSICS
""" GRAVITY """
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func apply_gravity(player: Entity, delta):
	if player is CharacterBody2D:
		player.velocity.y += Global.gravity * delta
		
""" ENTITY RUN """
func apply_acceleration_x(
	entity: Entity, acceleration: float, 
	end_speed = sign(acceleration) * 9999, air_control_percent: float = 1, delta = 1
):
	if entity:
		var current_acceleration = acceleration
		if !entity.is_on_floor():
			current_acceleration = acceleration * air_control_percent
		entity.velocity.x = approach(
			entity.velocity.x, end_speed, current_acceleration, 
			delta)

func apply_acceleration_y(
	entity: Entity, acceleration: float, 
	end_speed = sign(acceleration) * 9999, air_control_percent: float = 1, delta = 1
):
	if entity:
		var current_acceleration = acceleration
		if !entity.is_on_floor():
			current_acceleration = acceleration * air_control_percent
		entity.velocity.y = approach(
			entity.velocity.y, end_speed, current_acceleration, 
			delta)

func apply_acceleration_xy(
	entity: Entity, acceleration: Vector2, 
	end_velocity: Vector2, air_control_percent: float = 1, delta = 1
):
	if entity:
		var current_acceleration = acceleration
		if !entity.is_on_floor():
			current_acceleration = acceleration * air_control_percent
		
		entity.velocity += current_acceleration * delta

		if entity.velocity.length() > end_velocity.length():
			entity.velocity = end_velocity.length() * entity.velocity.normalized()

func apply_traction_x(entity: Entity, traction: float, air_control_percent: float = 1, delta = 1):
	if entity:
		var current_traction = traction
		if !entity.is_on_floor():
			current_traction = traction * air_control_percent
		entity.velocity.x = approach(entity.velocity.x, 0, current_traction * delta)

func apply_friction_x(entity: Entity, friction: float, air_control_percent: float = 1, delta = 1):
	if entity:
		var current_friction = friction
		if !entity.is_on_floor():
			current_friction = friction * air_control_percent
		entity.velocity.x = approach(entity.velocity.x, 0, current_friction * delta)
		
func apply_friction_y(entity: Entity, friction: float, delta = 1):
	if entity:
		var current_friction = friction
		entity.velocity.y = approach(entity.velocity.y, 0, current_friction * delta)

func player_move_x(player: Player, direction: int, move_speed: float, mod_factor: float, delta):
	# PLAYER MOVE CODE
	var move_velocity = direction * float(move_speed)
	if abs(player.velocity.x) <= abs(move_velocity):
		apply_acceleration_x(
			player, player.acceleration, move_velocity * mod_factor, 
			player.air_control_percent,
			delta)
	else:
		if abs(player.velocity.x) < move_speed:
			apply_traction_x(
				player, player.traction, player.air_control_percent,
				delta)
		else:
			apply_friction_x(
				player, player.friction, player.air_control_percent,
				delta)

func physics_move_x(entity: Entity, move_velocity: float, mod_factor: float, delta):
	var is_accelerating = ( round(entity.velocity.x) == 0
		or sign(move_velocity) == sign(entity.velocity.x)
	)
	
	# ENTITY MOVE CODE
	if abs(entity.velocity.x) <= abs(move_velocity) and is_accelerating:
		apply_acceleration_x(
			entity, entity.acceleration, move_velocity * mod_factor, 
			entity.air_control_percent, 
			delta)
	else:
		apply_friction_x(
			entity, entity.friction, entity.air_control_percent,
			delta)

func physics_move_y(entity: Entity, move_velocity: float, mod_factor: float, delta):
	var is_accelerating = ( round(entity.velocity.y) == 0
		or sign(move_velocity) == sign(entity.velocity.y)
	)
	
	# ENTITY MOVE CODE
	if abs(entity.velocity.y) <= abs(move_velocity) and is_accelerating:
		apply_acceleration_y(
			entity, entity.acceleration, move_velocity * mod_factor, 
			entity.air_control_percent, 
			delta)
	else:
		apply_friction_y(
			entity, entity.friction,
			delta)

func physics_move_xy(entity: Entity, move_velocity: Vector2, mod_factor: float, delta):
	var is_accelerating = ( round(entity.velocity.length()) == 0
		or entity.velocity.dot(move_velocity) > 0
	)
	
	# ENTITY MOVE CODE
	if entity.velocity.length() <= move_velocity.length() and is_accelerating:
		apply_acceleration_xy(
			entity, 
			move_velocity.normalized() * entity.acceleration, 
			move_velocity * mod_factor, 
			entity.air_control_percent,
			delta)
	else:
		apply_acceleration_xy(
			entity, 
			move_velocity.normalized() * entity.friction, 
			move_velocity * mod_factor, 
			entity.air_control_percent,
			delta)
#endregion

#region SCENE SWITCH

var current_scene = null

# Scene switch deferred to "down-time": after all other processes
func switch_scene(scene_resource: String):
	call_deferred("_deferred_switch_scene", scene_resource)

# Scene switch happens here!
func _deferred_switch_scene(scene_resource):
	current_scene.free()
	current_scene = load(scene_resource).instantiate()
	Map.add_child(current_scene)

#endregion
