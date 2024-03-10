extends Area2D
class_name Hurtbox

# Set on hit (passes to character body to move them)
var knockback_velocity := Vector2(0, 0)

@export var damage := 1.0

enum DIR {
	NONE,
	LEFT,
	RIGHT,
	UP,
	DOWN
}
@export var knockback : float = 200.0
@export var default_knockback_direction := DIR.NONE
# Informs knockback direction
var knockback_direction := default_knockback_direction

# For contantly attacking player
var damage_player_hitbox : Hitbox

# Hitboxes to ignore when looking to damage
var ignore_hitboxes := []

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and not ignore_hitboxes.has(area):
		
		set_knockback_dir(area)
		
		area.damage(self)
		
		# Start constant attack on player hitbox
		if area is PlayerHitbox:
			damage_player_hitbox = area
		else:
			add_ignore(area)

func _process(_delta):
	# Continue attack on player if vulnerable
	if damage_player_hitbox:
		damage_player_hitbox.damage(self)

# Cancel attack on player
func _on_area_exited(area):
	if damage_player_hitbox and area is PlayerHitbox:
		damage_player_hitbox = null

func refresh_ignore():
	ignore_hitboxes = []
	
func add_ignore(hitbox: Hitbox):
	ignore_hitboxes.append(hitbox)

func set_knockback_dir(area: Hitbox):
	var _knockback_dir := Vector2(area.global_position - global_position).normalized()
	_knockback_dir.y = -abs(_knockback_dir.y)
	
	match knockback_direction:
		DIR.LEFT:
			_knockback_dir = Vector2(-1.0, 0.0).normalized()
		DIR.RIGHT:
			_knockback_dir = Vector2(1.0, 0.0).normalized()
		DIR.UP:
			_knockback_dir = Vector2(0.0, -1.0).normalized()
		DIR.DOWN:
			_knockback_dir = Vector2(0.0, 1.0).normalized()
	
	knockback_velocity = _knockback_dir * knockback
