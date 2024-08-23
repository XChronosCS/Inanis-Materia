extends State

@export var ground_state: State
@export var active_power : String = "None"
@export var teleport_return_position_x: int = 0 #X position that pipe travel teleports Inanis to
@export var teleport_return_position_y: int = 0 #Y position that pipe travel teleports Inanis to

# State for all the Powers which have an animation that have an ending

func get_details(arguments: Array):
	if PowerStateMachine.current_power.alchemical_power == "Water" && active_power == "Drain":
		teleport_return_position_x = arguments[0]
		teleport_return_position_y = arguments[1]

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Burn":
		next_state = ground_state
		PowerStateMachine.power_in_use = false
	if anim_name == "Drain":
		character.global_position.x = teleport_return_position_x
		character.global_position.y = teleport_return_position_y
		playback.travel("Reform")
	if anim_name == "Reform":
		next_state = ground_state
		PowerStateMachine.power_in_use = false
	if anim_name == "Fill":
		next_state = ground_state
		PowerStateMachine.power_in_use = false
