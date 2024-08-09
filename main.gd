extends Node2D

@onready var background = $Sprite2D2
@onready var start_button = $Play

func admin_privledges():
	PowerStateMachine.power_obtained("Water")
	PowerStateMachine.power_obtained("Fire")
	PowerStateMachine.power_obtained("Earth")
	PowerStateMachine.power_obtained("Air")

func _ready():
	background.play("TitleScreen")
	start_button.grab_focus()
	PowerStateMachine.reset_power_tracker()



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
