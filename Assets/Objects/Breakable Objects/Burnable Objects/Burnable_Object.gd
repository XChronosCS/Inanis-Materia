extends StaticBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@export var starting_animation: String = ""
@export var burning_animation: String = ""
@onready var animation = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play(starting_animation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass

func _on_interact():
	interaction_area.interaction_disabled = not interaction_area.interaction_disabled
	await get_tree().create_timer(3.0).timeout
	animation.play(burning_animation)
	queue_free()


func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		if DataSave.flags.has_fire_power:
			DataSave.flags.fire_power_usable = true
			interaction_area.interaction_disabled = false


func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		interaction_area.interaction_disabled = true
		DataSave.flags.fire_power_usable = false
