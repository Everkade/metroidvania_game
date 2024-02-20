extends Line2D

@onready var collision_test: CharacterBody2D = $CollisionTest
@export var shooter: Node2D

func update_trajectory(dir: Vector2, speed: float, gravity: float, delta: float):
	var max_points = 300
	clear_points()
	var pos: Vector2 = Vector2.ZERO
	var vel = dir * speed
	for i in max_points:
		add_point(pos)
		vel.y += gravity * delta
		
		var collision: KinematicCollision2D = collision_test.move_and_collide(vel * delta, false, true, true)
		#if collision: vel = vel.bounce(collision.get_normal()) * 0.6
		
		# TODO since ground is on layer 1, ground is currently triggering collisions
		if collision and collision.get_collider().has_method("_on_player_take_damage"): 
			shooter.shoot()
			
		pos += vel * delta
		collision_test.position = pos
