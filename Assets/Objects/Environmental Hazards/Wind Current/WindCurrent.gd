extends Area2D

@onready var anim = get_node("AnimatedSprite2D")
@onready var interaction_area: InteractionArea = get_node("WindInteractionArea")
@onready var player: CharacterBody2D = null
@export var min_height: float = 300
@export var max_height: float = -400
@export var lift_speed: float = -20


func _ready():
	anim.play("Wind Current")
	interaction_area.interact = Callable(self, "_on_interact")
	
@warning_ignore("unused_parameter")
func _physics_process(delta):
	if DataSave.flags.air_power_activated:
			if clamp(player.position.y, max_height, min_height) == player.position.y:
				player.velocity.y += lift_speed
			else:
				player.position.y = max_height
				player.velocity.y = 0

	
func _on_interact():
		DataSave.flags.air_power_activated = not DataSave.flags.air_power_activated
		player.air_current_animation = not player.air_current_animation
		
		

func _on_wind_interaction_area_body_entered(body):
	if body.name == "Player":
		player = body
		if DataSave.flags.has_air_power:
			interaction_area.interaction_disabled = false
			DataSave.flags.air_power_usable = true


func _on_wind_interaction_area_body_exited(body):
	if body.name == "Player":
		player = body
		interaction_area.interaction_disabled = true
		DataSave.flags.air_power_usable = false
		DataSave.flags.air_power_activated = false
		player.air_current_animation = false



