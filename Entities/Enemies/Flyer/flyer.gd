extends Enemy

@onready var aggro_range: Area2D = $AggroRange

var player_body: Player
var target_offset := {
	"main": 44,
	"duck": 20
}

func _physics_process(delta: float) -> void:
	# Move toward player, vertical and horizontal
	if player_body:
		var _offset = (target_offset["main"]
			if not player_body.move_machine.current_state is PlayerDuck
			else target_offset["duck"]
		)
		var target = Vector2(
			player_body.global_position.x, 
			player_body.global_position.y - _offset
		)
		var move_direction := global_position.direction_to(target)
		move_direction *= base_speed
		
		Global.physics_move_xy(self, move_direction, 1.0, delta)
		
		move_and_slide()

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if not body is Player: return
	
	player_body = body
