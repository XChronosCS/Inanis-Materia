extends Area2D

@onready var anim = get_node("AnimatedSprite2D")
@onready var interaction_area: InteractionArea = get_node("WindInteractionArea")
@onready var player: CharacterBody2D = null
@export var min_height: float = 300
@export var max_height: float = -400
@export var lift_speed: float = -20
@onready var lift_enabled = false
@onready var audio_player = $AudioStreamPlayer
@onready var psm = PowerStateMachine


func _ready():
	anim.play("Wind Current")
	interaction_area.interact = Callable(self, "_on_interact")
	
@warning_ignore("unused_parameter")
func _physics_process(delta):
	if psm.correct_power_in_use("Air") and lift_enabled:
			if clamp(player.global_position.y, max_height, min_height) == player.global_position.y:
				player.velocity.y += lift_speed
			else:
				player.global_position.y = max_height
				player.velocity.y = 0

	
func _on_interact():
		if psm.current_power.alchemical_power == "Air":
			player.air_current_animation = not player.air_current_animation
			audio_player.play()
			lift_enabled = not lift_enabled
		
		

func _on_wind_interaction_area_body_entered(body):
	if body.name == "Player":
		player = body
		if psm.confirm_power_obtained("Air"):
			interaction_area.interaction_disabled = false



func _on_wind_interaction_area_body_exited(body):
	if body.name == "Player":
		player = body
		interaction_area.interaction_disabled = true
		psm.power_in_use = false
		player.air_current_animation = false
		lift_enabled = false



