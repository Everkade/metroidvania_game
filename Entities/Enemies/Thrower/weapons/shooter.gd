extends Node2D

@export var projectile_scene: PackedScene = preload("res://Entities/Enemies/Thrower/weapons/grenade.tscn")

@onready var trajectory_line: Line2D = $TrajectoryLine
@onready var throw_cooldown: Timer = $ThrowCooldown

var projectile_speed: float = 600.0
var projectile_gravity: float = 800.0
var can_throw := true
var enemy_in_range := false
var min_rotation_degrees := 240.0
var max_rotation_degrees := 300.0

func _process(delta: float) -> void:
	if !enemy_in_range: return
	
	var rotation_speed = 2 * delta
	
	# Rotating in a way that will create a high arc
	rotation += rotation_speed
	
	# Only let the thrower aim within the specified degrees
	if rotation_degrees < min_rotation_degrees:
		rotation_degrees = max_rotation_degrees
	elif rotation_degrees > max_rotation_degrees:
		rotation_degrees = min_rotation_degrees
	
	# Remove the rotation of the shooter from the line
	trajectory_line.rotation = -rotation
	
	trajectory_line.update_trajectory($ShootPos.global_transform.x, projectile_speed, projectile_gravity, delta)
		
func shoot() -> void:
	if !can_throw: return
	can_throw = false
	
	throw_cooldown.start()
	
	var instance = projectile_scene.instantiate()
	instance.dir = $ShootPos.global_transform.x
	instance.speed = projectile_speed
	instance.gravity = projectile_gravity
	# The parent of the projectile will be one level above the thrower
	# so that the projectile doesn't disappear on thrower death
	get_parent().get_parent().add_child(instance)
	instance.global_position = $ShootPos.global_position


func _on_throw_cooldown_timeout() -> void:
	can_throw = true
