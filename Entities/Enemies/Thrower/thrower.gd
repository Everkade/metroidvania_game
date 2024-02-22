extends Entity

@onready var aggro_range: Area2D = $AggroRange
@onready var shooter: Node2D = $Shooter

var player_body: Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()

func _on_aggro_range_body_entered(body: Node2D) -> void:
	player_body = body
	shooter.enemy_in_range = true

func _on_aggro_range_body_exited(body: Node2D) -> void:
	player_body = null
	shooter.enemy_in_range = false
