extends Node

class_name PowerState
@export var alchemical_power : String = "None"
@export var enabled : bool = false
signal PowerUsed

func state_input(event : InputEvent):
	pass
	
func state_process(delta):
	pass
	
func on_enter():
	pass
	
func on_exit():
	pass
