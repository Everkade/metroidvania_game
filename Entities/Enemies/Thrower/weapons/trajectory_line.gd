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
		if collision: 
			handle_collision(collision)
			
		pos += vel * delta
		collision_test.position = pos

func handle_collision(collision: KinematicCollision2D):
	if !collision.get_collider(): return
	
	var collider = collision.get_collider()
	
	if collider is Player:
		var recursive = true
		for child in collider.get_children():
			if child is Hitbox:
				shooter.shoot()
				break
