extends State

@export var previous_state: State

func on_enter():
	previous_state = character.get_previous_state()

func end_cutscene():
	next_state = previous_state
	
