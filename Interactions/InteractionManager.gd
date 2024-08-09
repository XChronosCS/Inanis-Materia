extends Node2D

@onready var player = get_tree().get_first_node_in_group("Players")

var active_areas = []
var can_interact = true
var interaction_powers: Array[String] = PowerStateMachine.interactable_powers

func _ready():
	# Connects signal from global Power State Machine to function
	PowerStateMachine.use_power.connect(_on_use_power)


func register_area(area: InteractionArea):
	active_areas.push_back(area)
	interaction_powers.append(area.power_needed)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
	# Removes area from list of powers that can currently be used
	var power_index = interaction_powers.find(area.power_needed)
	if power_index != -1:
		interaction_powers.remove_at(power_index)

@warning_ignore("unused_parameter")
func _process(delta):
	player = get_tree().get_first_node_in_group("Players")
	
	
	
# Receives signal from PowerStateMachine
func _on_use_power(power):
	print("Signal Received")
	if active_areas.size() > 0:
		print(interaction_powers)
		for active_area in active_areas:
			# If the current power being used matches one of the interaction areas needed powers
			if active_area.power_needed == power && can_interact:
				if active_areas.size() > 0:
					can_interact = false
					PowerStateMachine.power_in_use = !PowerStateMachine.power_in_use
					await active_area.interact.call()
					can_interact = true
	
