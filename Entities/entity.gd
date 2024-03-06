extends CharacterBody2D
class_name Entity

enum DIR {
	LEFT,
	RIGHT
}

# Can be set to flip the default looking direction of entities
@export var facing : Entity.DIR = DIR.RIGHT

# All entities can be flagged as invulnerable (to ingore damage to Health)
var invulnerable := false

@onready var _sprite : Sprite2D = $Sprite2D

func _on_entity_hit(_damage):
	_sprite.follow_blend_factor = _sprite.hit_blend_factor
