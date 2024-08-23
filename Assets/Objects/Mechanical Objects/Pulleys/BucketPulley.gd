extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = null
@onready var psm = PowerStateMachine
@export var audio_player: AudioStreamPlayer

signal BucketFilled

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.play("Default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_interact():
	if psm.current_power.alchemical_power == "Water":
		InteractionManager.unregister_area(interaction_area)
		sprite.play("Pulley")
		await get_tree().create_timer(1).timeout
		audio_player.play()
		BucketFilled.emit()



func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		pass



func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		pass
