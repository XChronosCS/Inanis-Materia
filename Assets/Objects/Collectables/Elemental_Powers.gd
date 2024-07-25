extends Area2D

@export var playing_animation: String = ""
@onready var animation = get_node("AnimationPlayer")

func _ready():
	animation.play(playing_animation)

func _on_body_entered(body):
	if body.name == "Player":
		if playing_animation == "Air Power":
			body.air_power = true
		queue_free()
			
