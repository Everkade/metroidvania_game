extends Node2D
class_name State

signal Transitioned
@onready var entity = get_parent().get_parent()

func enter():
	pass
	
func exit():
	pass
	
func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
