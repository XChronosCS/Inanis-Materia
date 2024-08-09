extends Node

@export var current_power : PowerState
@export var previous_power : PowerState
@export var next_power : PowerState
@export var interactable_powers: Array[String]
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer
signal use_power
var power_index: int = 0
@export var power_in_use: bool = false

# 2 Arrays. One of all states possible, one of all states currently usable as powers
var states : Array[PowerState]
var powers : Array[PowerState]


func _ready():
	for child in get_children():
		if child is PowerState:
			states.append(child)
		else:
			push_warning("Child " + child.name + "is not State for PowerStateMachine")
			
func power_obtained(power_name: String):
	for child in get_children():
		if child is PowerState:
			if child.alchemical_power == power_name:
				child.enabled = true
				powers.append(child)
				update_power_tracker()

func confirm_power_obtained(power_needed: String):
	for item in powers:
		if item.alchemical_power == power_needed:
			return true
	return false

func get_index_for_power(go_right: bool):
	if go_right: # Increasing the index to the right
		if power_index == powers.size() - 1:
			return 0
		else:
			return power_index + 1
	else:
		if power_index == 0:
			return powers.size() - 1
		else:
			return power_index - 1
			
func update_power_tracker():
	current_power = powers[power_index]
	next_power = powers[get_index_for_power(true)]
	previous_power = powers[get_index_for_power(false)]

func correct_power_in_use(power: String):
	return power_in_use and current_power.alchemical_power == power
	
func reset_power_tracker():
	powers.clear()
	current_power = null
	next_power = null
	previous_power = null

# Checks for Power Use Button Press
func _input(event):
	if powers.size() != 0:
		if event.is_action_pressed("use_power"):
			# Performs any input specific mechanics on the current power, such as resource bars
			current_power.state_input(event)
			# Sends out a signal that a power has been used, and which one it was
			use_power.emit(current_power.alchemical_power)
		elif event.is_action_pressed("power_left") or event.is_action_pressed("power_right"):
			if not power_in_use:
				var go_right : bool
				if event.is_action_pressed("power_left"):
					go_right = false
				if event.is_action_pressed("power_right"):
					go_right = true
				audio_player.play()
				power_index = get_index_for_power(go_right)
				update_power_tracker()
	
