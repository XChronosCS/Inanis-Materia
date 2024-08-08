extends State

var jump_velocity : float = -400.0
@export var air_state: State
@export var push_state: State
@export var jump_animation : String = "Jump"

# Called when the node enters the scene tree for the first time.
func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()

func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation)

func pushing():
	next_state = push_state
	
