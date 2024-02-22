extends Node2D

func _ready():
	Map.load_map()
	queue_free()
