extends Entity

@onready var grenade_duration: Timer = $GrenadeDuration

var dir := Vector2.ZERO
var speed: float
var gravity: float
var can_damage := true

@onready var _attack: Node = $Attack

func _ready() -> void:
	velocity = dir * speed
	
func _physics_process(delta: float) -> void:
	var rotation_speed = 8 * delta
	
	rotation += rotation_speed
	velocity.y += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if not collision: return
	
	_handle_collision(collision.get_collider())
	
	# Remove this if the grenade shouldn't bounce
	#velocity = velocity.bounce(collision.get_normal()) * 0.6

func _on_grenade_duration_timeout() -> void:
	queue_free()

func _handle_collision(collider: Object) -> void:
	if !can_damage || !collider.has_method("_on_player_take_damage"):
		return
	can_damage = false
	
	collider._on_player_take_damage(_attack)
	
	queue_free()
