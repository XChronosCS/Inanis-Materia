extends Area2D

@export var playing_animation: String = ""
@onready var animation = get_node("AnimationPlayer")
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	animation.play(playing_animation)

func _on_body_entered(body):
	if body.name == "Player":
		if playing_animation == "Air Power":
			PowerStateMachine.power_obtained("Air")
		if playing_animation == "Earth Power":
			PowerStateMachine.power_obtained("Earth")
		if playing_animation == "Water Power":
			PowerStateMachine.power_obtained("Water")
		if playing_animation == "Fire Power":
			PowerStateMachine.power_obtained("Fire")
		if not audio.is_playing():
			audio.play()
		visible = false
			


func _on_audio_stream_player_finished():
	queue_free()
