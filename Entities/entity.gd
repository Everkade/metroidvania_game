extends CharacterBody2D
class_name Entity

enum DIR {
	LEFT,
	RIGHT
}

@export var facing : Entity.DIR = DIR.RIGHT

var invulnerable := false
