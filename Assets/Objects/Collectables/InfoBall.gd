extends Area2D

@onready var animation = get_node("AnimatedSprite2D")
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	animation.play("InfoBall")

func _on_body_entered(body):
	if body.name == "Player":
		body.enter_cutscene()
		audio.play()
		visible = false


func _on_audio_stream_player_finished():
	queue_free()
