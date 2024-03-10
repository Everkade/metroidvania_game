extends Node2D
class_name Upgrade

# Manage upgrades 

@export var base_health_add := 0

@onready var health : Health = get_node("../Health")
@onready var base_health := health.max_health if health else 3.0
