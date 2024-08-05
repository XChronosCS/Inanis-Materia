extends Node2D

@onready var background = $Sprite2D2

func admin_privledges():
	DataSave.flags.has_air_power = true
	DataSave.flags.has_earth_power = true
	DataSave.flags.has_fire_power = true
	DataSave.flags.has_water_power = true

func _ready():
	background.play("TitleScreen")



func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	transition.transition_to("res://Assets/Levels/Level 1/level_1.tscn")
	


func _on_play_2_pressed():
	admin_privledges()
	transition.transition_to("res://Assets/Levels/Level 2/level_2.tscn")
	  


func _on_play_3_pressed():
	admin_privledges()
	transition.transition_to("res://Assets/Levels/Level 3/level_3.tscn")


func _on_play_4_pressed():
	admin_privledges()
	transition.transition_to("res://Assets/Levels/Level 4/level_4.tscn")
