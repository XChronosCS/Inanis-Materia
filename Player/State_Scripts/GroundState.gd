extends State

var jump_velocity : float = -400.0
@export var air_state: State
@export var push_state: State
@export var fall_state: State
@export var use_power_state : State
@export var death_state: State
@export var jump_animation : String = "Jump"
@export var fall_animation : String = "Fall"
@export var burn_item_animation : String = "Burn"
@export var drain_animation: String = "Drain"
@export var push_animation: String = "Push"
@export var coyote_timer: Timer
@onready var jump_buffer_stored: bool = false


func on_enter():
	if jump_buffer_stored:
		buffer_jump(false)
		jump()
	buffer_jump(false)
	

# Called when the node enters the scene tree for the first time.
func state_input(event : InputEvent):
	if event.is_action_pressed("jump") and PowerStateMachine.confirm_power_obtained("Air") and (character.is_on_floor() or coyote_timer.coyote):
		jump()
	if event.is_action_pressed("use_power"):
		if InteractionManager.power_use_available(PowerStateMachine.current_power.alchemical_power):
			match PowerStateMachine.current_power.alchemical_power:
				"Fire":
					next_state = use_power_state
					playback.travel(burn_item_animation)
				"Water":
					next_state = use_power_state
					use_power_state.active_power = "Drain"
					playback.travel(drain_animation)
				"Earth":
					next_state = push_state
					character.set_collision_mask_value(3, false)
					playback.travel(push_animation)

func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation)

func pushing():
	next_state = push_state

func state_process(delta):
	if not character.is_on_floor():
		if coyote_timer.last_floor:
			coyote_timer.coyote = true
			coyote_timer.start()
		elif not coyote_timer.coyote:
			next_state = fall_state
			playback.travel(fall_animation)
	coyote_timer.last_floor = character.is_on_floor() # Enables Coyote Time only when placed in this spot
	
func buffer_jump(mode: bool):
	jump_buffer_stored = mode
	
func force_move():
	if character.death_flag:
		next_state = death_state
		playback.travel("Death")
