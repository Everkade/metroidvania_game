extends Node2D

@export var projectile_scene: PackedScene = preload("res://Entities/Enemies/Thrower/weapons/grenade.tscn")

@export var throw_cooldown_frames: int = 60
var throw_cooldown_time : float = throw_cooldown_frames / 60.0
var throw_cooldown_count := 0.0

var target = null
var dir := 1
var projectile_speed: float = 550.0
var projectile_gravity: float = 800.0

func _process(delta: float) -> void:
	if !target: return
	
	if throw_cooldown_count <= 0:
		shoot()
		throw_cooldown_count = throw_cooldown_time
	else:
		throw_cooldown_count -= delta
	
	# Rotating in a way that will create a high arc
	#rotation += delta
	
func shoot() -> void:
	var _angle = Global.get_throw_angle(
		global_position, target.global_position, projectile_speed, projectile_gravity
	)
	
	# If there is a valid throw angle
	if _angle:
		var projectile = projectile_scene.instantiate()
		projectile.angle = _angle
		projectile.dir = sign(target.global_position.x - global_position.x)
		projectile.speed = projectile_speed
		projectile.gravity = projectile_gravity
		projectile.set_projectile_velocity()
		# The parent of the projectile will be one level above the thrower
		# so that the projectile doesn't disappear on thrower death
		get_parent().get_parent().add_child(projectile)
		projectile.global_position = global_position
