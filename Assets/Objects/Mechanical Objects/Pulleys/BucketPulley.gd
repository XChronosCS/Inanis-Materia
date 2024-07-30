extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = null
@onready var interacted_with = false

signal BucketFilled

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.play("Default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_interact():
	if DataSave.flags.has_water_power && not interacted_with:
		interaction_area.interaction_disabled = not interaction_area.interaction_disabled
		DataSave.flags.earth_power_activated = true
		interacted_with = true
		sprite.play("Pulley")
		await get_tree().create_timer(2).timeout
		BucketFilled.emit()
		DataSave.flags.water_power_usable = false
		DataSave.flags.earth_power_activated = false



func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		if DataSave.flags.has_water_power && not interacted_with:
			interaction_area.interaction_disabled = false
			DataSave.flags.water_power_usable = true



func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		player = body
		interaction_area.interaction_disabled = true
		DataSave.flags.water_power_usable = false
		DataSave.flags.water_power_activated = false
