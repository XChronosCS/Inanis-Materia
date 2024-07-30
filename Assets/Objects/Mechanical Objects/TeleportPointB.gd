extends Node2D

@onready var interaction_area = $InteractionAreaB
@onready var player: CharacterBody2D = null
@onready var arrow = $AnimatedSprite2D2
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
	interaction_area.interaction_disabled = not interaction_area.interaction_disabled
	arrow.hide()
	DataSave.flags.water_power_activated = true
	player.anim.play("Drain")
	player.melt_animation = true
	await get_tree().create_timer(1).timeout
	teleportingInProgress.emit(player)

func _on_interaction_area_b_body_entered(body):
	if body.name == "Player":
		player = body
		if DataSave.flags.has_water_power:
			interaction_area.interaction_disabled = false
			DataSave.flags.water_power_usable = true
			arrow.show()


func _on_interaction_area_b_body_exited(body):
	if body.name == "Player":
		player = body
		interaction_area.interaction_disabled = true
		DataSave.flags.water_power_usable = false
		DataSave.flags.water_power_activated = false
		arrow.hide()

func _on_point_a_teleporting_in_progress(player_data):
	player = player_data
	player.global_position.x = global_position.x
	player.global_position.y = global_position.y
	player.show()
	player.anim.play("Reform")
	
