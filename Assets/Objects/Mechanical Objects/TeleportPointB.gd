extends Node2D

@onready var interaction_area = $InteractionAreaB
@onready var player: CharacterBody2D = null
@onready var arrow = $AnimatedSprite2D2
@onready var psm = PowerStateMachine
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	arrow.hide()
	arrow.play("default")

signal teleportingInProgress


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interact():
	if psm.current_power.alchemical_power == "Water":
		arrow.hide()
		teleportingInProgress.emit(player)
		
func _on_interaction_area_b_body_entered(body):
	if body.name == "Player":
		player = body
		if psm.confirm_power_obtained("Water"):
			arrow.show()

func _on_interaction_area_b_body_exited(body):
	if body.name == "Player":
		player = body
		psm.power_in_use = false
		arrow.hide()

func _on_point_a_teleporting_in_progress(player_data):
	player = player_data
	player.state_machine.give_details([global_position.x, global_position.y])
	
	
