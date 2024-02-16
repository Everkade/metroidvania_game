extends Node

var current_scene = null
var current_room : Room = null
var room_change_node_name : String = ""

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	if current_scene is Room:
		current_room = current_scene

func switch_scene(scene_resource: String):
	call_deferred("_deferred_switch_scene", scene_resource)

func _deferred_switch_scene(scene_resource):
	current_scene.free()
	current_scene = load(scene_resource).instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	if current_scene is Room:
		current_room = current_scene

func switch_room(room_resource: String, room_change_name = ""):
	switch_scene(room_resource)
	room_change_node_name = room_change_name

# Global helper data and variables
func approach(start_val, end_val, spd, delta = 1) -> float:
	var new_val = start_val
	if start_val < end_val:
		new_val = start_val + spd * delta
		new_val = clamp(new_val, start_val, end_val)
	elif start_val > end_val:
		new_val = start_val - spd * delta
		new_val = clamp(new_val, end_val, start_val)
	return new_val

func set_slip_margin(entity: Entity, hitbox: Hitbox):
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
var gravity = 1000
func apply_gravity(player: Entity, delta):
	if player is CharacterBody2D:
		player.velocity.y += Global.gravity * delta
		
""" ENTITY RUN """
func apply_acceleration(
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
		
func apply_friction(entity: Entity, friction: float, air_control_percent: float = 1, delta = 1):
	if entity:
		var current_friction = friction
		if !entity.is_on_floor():
			current_friction = friction * air_control_percent
		entity.velocity.x = approach(entity.velocity.x, 0, current_friction * delta)
		
func apply_traction(entity: Entity, traction: float, air_control_percent: float = 1, delta = 1):
	if entity:
		var current_traction = traction
		if !entity.is_on_floor():
			current_traction = traction * air_control_percent
		entity.velocity.x = approach(entity.velocity.x, 0, current_traction * delta)	

func run_move(entity: Entity, direction, run_speed, delta):
	if entity is Player:
		# PLAYER RUN CODE
		var run_velocity = direction * run_speed
		if abs(entity.velocity.x) <= abs(run_velocity):
			apply_acceleration(
				entity, entity.acceleration, run_velocity, entity.air_control_percent,
				delta)
		else:
			if abs(entity.velocity.x) < run_speed:
				apply_traction(
					entity, entity.traction, entity.air_control_percent,
					delta)
			else:
				apply_friction(
					entity, entity.friction, entity.air_control_percent,
					delta)
	else:
		# Entity run code here
		pass
#endregion
