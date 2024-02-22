extends Entity

@onready var grenade_duration: Timer = $GrenadeDuration

var dir := Vector2.ZERO
var speed: float
var gravity: float

func _ready() -> void:
	velocity = dir * speed
	
func _physics_process(delta: float) -> void:
	var rotation_speed = 8 * delta
	
	rotation += rotation_speed
	velocity.y += gravity * delta
	
	# Remove this if the grenade shouldn't bounce
	#velocity = velocity.bounce(collision.get_normal()) * 0.6

func _on_grenade_duration_timeout() -> void:
	queue_free()
