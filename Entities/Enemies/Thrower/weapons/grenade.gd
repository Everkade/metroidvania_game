extends Entity

var dir := Vector2.ZERO
var speed: float
var gravity: float
var can_damage := true

@onready var grenade_duration: Timer = $GrenadeDuration

func _ready() -> void:
	velocity = dir * speed
	
func _physics_process(delta: float) -> void:
	var rotation_speed = 8 * delta
	
	rotation += rotation_speed
	velocity.y += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if not collision: return
	
	_handle_collision(collision)
	
	# Remove this if the grenade shouldn't bounce
	#velocity = velocity.bounce(collision.get_normal()) * 0.6

func _on_grenade_duration_timeout() -> void:
	queue_free()

func _handle_collision(collision: KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	
	if collider is Player:
		for child in collider.get_children():
			if child is Hitbox:
				child.damage(self)
				can_damage = false
				break
	
	queue_free()
