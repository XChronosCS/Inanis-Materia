extends Node2D



func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	transition.transition_to("res://Assets/Levels/Level 1/level_1.tscn")
	


func _on_play_2_pressed():
	transition.transition_to("res://Assets/Levels/Level 2/level_2.tscn")
	  


func _on_play_3_pressed():
	transition.transition_to("res://Assets/Levels/Level 3/level_3.tscn")


func _on_play_4_pressed():
	transition.transition_to("res://Assets/Levels/Level 4/level_4.tscn")
