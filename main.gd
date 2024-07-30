extends Node2D



func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Assets/Levels/Level 3/level_3.tscn")
	


func _on_play_2_pressed():
	get_tree().change_scene_to_file("res://World.tscn")
	  
