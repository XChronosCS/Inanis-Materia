extends Node

class_name CharacterStateMachine

@export var previous_state: State
@export var current_state : State 
@export var animation_tree : AnimationTree
@export var player : CharacterBody2D

var states : Array[State]

func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			
			# Set the states up with what they need to function
			child.character = player
			child.playback = animation_tree["parameters/playback"]
		else:
			push_warning("Child " + child.name + "is not State for CharacterStateMachine")
			
func _physics_process(delta):
	if current_state.next_state != null:
		switch_states(current_state.next_state)
	current_state.state_process(delta)

func check_can_move():
	return current_state.can_move

func switch_states(next_state : State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
	previous_state = current_state
	current_state = next_state
	current_state.on_enter()
	
func _input(event):
	current_state.state_input(event)
	
func give_details(arguments: Array):
	current_state.get_details(arguments)
