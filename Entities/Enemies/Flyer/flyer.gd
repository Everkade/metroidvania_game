extends Entity

@export var base_max_speed := 200
@onready var aggro_range: Area2D = $AggroRange

var player_body: Node2D
var _speed
@onready var _attack: Node = $Attack

func _ready() -> void:
	_speed = base_max_speed

func _physics_process(delta: float) -> void:
	# Move toward player, vertical and horizontal
	if player_body:
		var direction := global_position.direction_to(player_body.global_position)
		velocity = direction * _speed
		var collision: KinematicCollision2D = move_and_collide(velocity * delta, false, true, true)
		if collision: 
			_handle_collision(collision.get_collider())

func _on_aggro_range_body_entered(body: Node2D) -> void:
	# Could instead look for method
	# if body.has_method("take_damage"): ...
	if body.name != "Player": return
	
	player_body = body

func _handle_collision(collider: Object):
	if !collider.has_method("_on_player_take_damage"): return
	collider._on_player_take_damage(_attack)
	
	# For testing purposes, it's nice if we don't spam the player with damage
	queue_free()
