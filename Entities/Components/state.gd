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
	
# Helper functions
func transition_to(state_name: String):
	Transitioned.emit(self, state_name)

func transition_to_main():
	transition_to("main")
