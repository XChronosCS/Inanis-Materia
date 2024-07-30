extends Node2D

@onready var FirePower = $"Elemental Powers"
@onready var textbox1 = $L4Textbox1
@onready var textbox2 = $L4Textbox2
@onready var base_tilemap = $TileMap
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	DataSave.flags.current_level = 4
	FirePower.visible = false
	FirePower.process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_chain_switch_open_the_gates():
	base_tilemap.set_layer_enabled(6, false)


func _on_l_4_info_ball_1_body_entered(body):
	textbox1.visible = true
	DataSave.flags.prevent_player_movement = true


func _on_l_4_info_ball_2_body_entered(body):
	textbox2.visible = true
	DataSave.flags.prevent_player_movement = true
	
func _on_l_4_textbox_1_text_trigger_reached():
	FirePower.process_mode = Node.PROCESS_MODE_ALWAYS
	FirePower.visible = true
	FirePower.animation.play(FirePower.playing_animation)




func _on_box_death_plane_body_entered(body):
	if body.is_in_group("Pushable Objects"):
		body.queue_free()


func _on_next_level_body_entered(body):
	if body.name == "Player":
		transition.transition_to("res://the_end.tscn")
