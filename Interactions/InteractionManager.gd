extends Node2D

@onready var player = get_tree().get_first_node_in_group("Players")
@onready var label = $CanvasLayer/Label


const base_text = "] to "

var active_areas = []
var can_interact = true


func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

@warning_ignore("unused_parameter")
func _process(delta):
	player = get_tree().get_first_node_in_group("Players")
	label.text = ""
	if active_areas.size() > 0 && can_interact:
		for active_area in active_areas:
			if active_area.interaction_disabled != true:
				label.text += "[" + active_area.keyboard_key + base_text + active_area.action_name + "\n"
		# player.recent_action = active_areas[0].action_name # Sets the recent action variable to the most recent action displayed
		label.show()
	else:
		#if label != null:
			#label.hide()
			pass
		
		
	

func _input(event):
	if active_areas.size() > 0:
		for active_area in active_areas:
			if event.is_action_pressed(active_area.interaction_key) && can_interact:
				if active_areas.size() > 0:
					can_interact = false
					label.hide()
					await active_area.interact.call()
					can_interact = true
	
