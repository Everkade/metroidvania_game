extends Entity

@export var base_max_speed := 200
@onready var aggro_range: Area2D = $AggroRange

var player_body: Node2D
var _speed

func _ready() -> void:
	_speed = base_max_speed

func _physics_process(_delta: float) -> void:
	# Move toward player, vertical and horizontal
	if player_body:
		var direction := global_position.direction_to(player_body.global_position)
		velocity = direction * _speed
		move_and_slide()

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.name != "Player": return
	
	player_body = body
