extends Node2D

@onready var jump_sign = $JumpControlsSign
@onready var AirPower = $"Elemental Powers"
@onready var textbox1 = $Textbox1
@onready var textbox2 = $Textbox2
@onready var powerTracker = $PowerTracker


# Called when the node enters the scene tree for the first time.
func _ready():
	DataSave.flags.current_level = 1
	AirPower.visible = false
	powerTracker.visible = false
	AirPower.process_mode = Node.PROCESS_MODE_DISABLED
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		


func _on_elemental_powers_body_entered(body):
	pass

# InfoBall Code

func _on_info_ball_1_body_entered(body):
	textbox1.visible = true
	DataSave.flags.prevent_player_movement = true


func _on_info_ball_2_body_entered(body):
	textbox2.visible = true
	DataSave.flags.prevent_player_movement = true


func _on_textbox_2_text_trigger_reached():
	AirPower.process_mode = Node.PROCESS_MODE_ALWAYS
	AirPower.visible = true
	powerTracker.visible = true
	AirPower.animation.play(AirPower.playing_animation)


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		transition.transition_to("res://Assets/Levels/Level 2/level_2.tscn")
