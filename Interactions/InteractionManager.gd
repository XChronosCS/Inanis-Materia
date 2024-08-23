extends Node2D

@onready var player = get_tree().get_first_node_in_group("Players")

var active_areas = []
var can_interact = true
var detailed_interaction_powers: Array[Dictionary] = PowerStateMachine.detailed_interactable_powers
var simple_interaction_powers: Array[String] = PowerStateMachine.interactable_powers

func _ready():
	# Connects signal from global Power State Machine to function
	PowerStateMachine.use_power.connect(_on_use_power)


func register_area(area: InteractionArea):
	active_areas.push_back(area)
	detailed_interaction_powers.append({"Power": area.power_needed, "Subset": area.power_subset_needed})
	simple_interaction_powers.append(area.power_needed)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
	# Removes area from list of powers that can currently be used
	for item in detailed_interaction_powers:
		if item["Power"] == area.power_needed and item["Subset"] == area.power_subset_needed:
			@warning_ignore("confusable_local_declaration")
			var power_index = detailed_interaction_powers.find(item)
			if power_index != -1:
				detailed_interaction_powers.remove_at(power_index)
	var power_index = simple_interaction_powers.find(area.power_needed)
	if power_index != -1:
		simple_interaction_powers.remove_at(power_index)

@warning_ignore("unused_parameter")
func _process(delta):
	player = get_tree().get_first_node_in_group("Players")
	

func power_use_available(power: String):
	for item in detailed_interaction_powers:
		if item["Power"] == power:
			PowerStateMachine.interaction_power_subset = item["Subset"]
			return true
	return false
	
	
# Receives signal from PowerStateMachine
func _on_use_power(power):
	if active_areas.size() > 0:
		for active_area in active_areas:
			# If the current power being used matches one of the interaction areas needed powers
			if active_area.power_needed == power && can_interact:
				if active_areas.size() > 0:
					can_interact = false
					PowerStateMachine.power_in_use = !PowerStateMachine.power_in_use
					await active_area.interact.call()
					can_interact = true
	
