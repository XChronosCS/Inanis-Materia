extends Area2D

@onready var animation = get_node("AnimatedSprite2D")

func _ready():
	animation.play("InfoBall")

func _on_body_entered(body):
	if body.name == "Player":
		queue_free()
