extends Enemy

@onready var aggro_range: Area2D = $AggroRange
@onready var avoid_range: Area2D = $AvoidRange
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision: RayCast2D = $Vision

var is_sight_set := false
var can_see_player := false
var is_target_player := false

#var cant_see_slow_factor := 1.0
#var cant_see_slow_factor_speed := 0.1

var avoid_vector := Vector2(0, 0)

var player_body: Player
var target_offset := {
	"main": 20,
	"duck": 10
}

func _ready():
	play_animation("fly", 1.75)
	

func _physics_process(delta: float) -> void:
	if is_sight_set: 
		can_see_player = not vision.is_colliding()
		if not is_target_player:
			is_target_player = can_see_player
	
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
		
		set_sight_position(target)
		
		if is_target_player:
			#var cant_see_slow_factor_follow = 1.0 if can_see_player else 0.25
			#cant_see_slow_factor = Global.approach(cant_see_slow_factor,
				#cant_see_slow_factor_follow, cant_see_slow_factor_speed,
				#delta
			#)
			#print(cant_see_slow_factor)
			nav_agent.target_position = target
			
			if not can_see_player:
				var _player_in_aggro = false
				for body in aggro_range.get_overlapping_bodies():
					_player_in_aggro = body is Player
					if _player_in_aggro: break
				if not _player_in_aggro: 
					pass
	
	var move_direction := get_navigation_direction()
	move_direction *= base_speed
	Global.physics_move_xy(self, move_direction, 1.0, delta)
	
	avoid_vector = Global.avoid_bodies_in_area(self, Enemy, avoid_range, 100, delta)
	if nav_agent.debug_enabled: queue_redraw()
	
	move_and_slide()

func set_sight_position(target_position: Vector2):
	vision.target_position = target_position - global_position
	is_sight_set = true

func get_navigation_direction() -> Vector2:
	var _axis = Vector2(0, 0)
	if not nav_agent.is_navigation_finished():
		var _dir = nav_agent.get_next_path_position() - global_position
		_axis = _dir.normalized()
	return _axis

func _draw():
	if nav_agent.debug_enabled:
		draw_line(Vector2(0, 0), avoid_vector * 50, Color.RED, 1.0)
		var _color = Color.GREEN if can_see_player else Color.GRAY
		draw_line(Vector2(0, 0), vision.target_position, _color, 1.0)

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if not body is Player: return
	
	player_body = body
