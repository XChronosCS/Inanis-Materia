extends State

@export var ground_state: State
@export var death_state: State
@export var ground_detect: RayCast2D

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		if ground_detect.is_colliding():
			ground_state.buffer_jump(true)
			print("Jump Buffered")

func state_process(delta):
	if character.is_on_floor():
		next_state = ground_state
		playback.travel("Land")
		
func force_move():
	if character.death_flag:
		next_state = death_state
		playback.travel("Death")
