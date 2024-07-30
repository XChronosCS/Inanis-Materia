extends Node2D

@onready var WaterPower = $"Elemental Powers"
@onready var textbox1 = $L3Textbox1
@onready var textbox2 = $L3Textbox2
@onready var base_tilemap = $TileMap
@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	DataSave.flags.current_level = 3
	WaterPower.visible = false
	WaterPower.process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bucket_pulley_bucket_filled():
	base_tilemap.set_layer_enabled(6, false)


func _on_l_3_info_ball_1_body_entered(body):
	textbox1.visible = true
	DataSave.flags.prevent_player_movement = true


func _on_l_3_info_ball_2_body_entered(body):
	textbox2.visible = true
	DataSave.flags.prevent_player_movement = true


func _on_l_3_textbox_1_text_trigger_reached():
	WaterPower.process_mode = Node.PROCESS_MODE_ALWAYS
	WaterPower.visible = true
	WaterPower.animation.play(WaterPower.playing_animation)


func _on_next_level_body_entered(body):
	if body.name == "Player":
		transition.transition_to("res://Assets/Levels/Level 4/level_4.tscn")
