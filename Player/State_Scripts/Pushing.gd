extends State

@export var ground_state: State
@export var death_state: State

func state_process(delta):
	PowerStateMachine.power_in_use = true

func state_input(event : InputEvent):
	if event.is_action_pressed("use_power"):
		if InteractionManager.power_use_available(PowerStateMachine.current_power.alchemical_power):
			match PowerStateMachine.current_power.alchemical_power:
				"Earth":
					force_move()

func force_move():
	if character.death_flag:
		next_state = death_state
		playback.travel("Death")
	next_state = ground_state
	character.set_collision_mask_value(3, true)
	playback.travel("Move")
