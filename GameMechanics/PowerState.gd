extends Node

class_name PowerState
@export var alchemical_power : String = "None"
@export var enabled : bool = false
signal PowerUsed

@warning_ignore("unused_parameter")
func state_input(event : InputEvent):
	pass
	
@warning_ignore("unused_parameter")
func state_process(delta):
	pass
	
func on_enter():
	pass
	
func on_exit():
	pass
