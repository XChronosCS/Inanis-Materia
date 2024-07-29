extends Node2D

@onready var EarthPower = $"Elemental Powers"
@onready var textbox1 = $L2Textbox1
@onready var textbox2 = $L2Textbox2
@onready var powerTracker = $PowerTracker
@onready var player = $Player
@onready var starting_position_x = 0
@onready var starting_position_y = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	DataSave.flags.current_level = 2
	EarthPower.visible = false
	EarthPower.process_mode = Node.PROCESS_MODE_DISABLED
	starting_position_x = player.position.x
	starting_position_y = player.position.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_l2_info_ball_1_body_entered(body):
	textbox1.visible = true
	DataSave.flags.prevent_player_movement = true


func _on_l2_info_ball_2_body_entered(body):
	textbox2.visible = true
	DataSave.flags.prevent_player_movement = true
	

func _on_spike_death_body_entered(body):
	if body.name == "Player":
		player.position.x = starting_position_x
		player.position.y = starting_position_y # Replace with function body.


func _on_l_2_textbox_2_text_trigger_reached():
	EarthPower.process_mode = Node.PROCESS_MODE_ALWAYS
	EarthPower.visible = true
	EarthPower.animation.play(EarthPower.playing_animation)
