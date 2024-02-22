extends CanvasLayer

signal Ended

@export var fade_in_sec : float = 0.2
@export var fade_out_sec : float = 0.2
@export var fade_out_delay_sec : float = 0.05

var fade_end_sec : float = -1.0
var fade_count : float = 0.0
var fade_out_delay_count : float = 0.0

var in_transition := false
var transition_type := ""

func transition(fade_string : String):
	
	in_transition = true
	fade_count = 0.0
	fade_out_delay_count = 0.0
	
	if fade_string == "in":
		$ColorRect.color.a = 0.0
		transition_type = "in"
		fade_end_sec = fade_in_sec
	elif fade_string == "out":
		$ColorRect.color.a = 1.0
		transition_type = "out"
		fade_end_sec = fade_out_sec
		fade_out_delay_count = fade_out_delay_sec
	else:
		transition_type = ""
		fade_end_sec = -1.0


func _process(delta) -> void:

	if in_transition:
		
		# Exit blackscreen delay
		if fade_out_delay_count > 0:
			fade_out_delay_count -= delta
			return
		
		fade_count += delta
		if fade_end_sec != -1.0 and fade_count > fade_end_sec:
			fade_count = fade_end_sec
		
		var n = fade_count / fade_end_sec
		$ColorRect.color.a = (
			n if transition_type == "in"
			else 1.0 - n if transition_type == "out"
			else 0.0
		)
		
		var transition_ended = (
			(transition_type == "in" and $ColorRect.color.a == 1.0) or
			(transition_type == "out" and $ColorRect.color.a == 0.0)
		)
		if transition_ended:
			Ended.emit()
			in_transition = false

