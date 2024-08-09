extends CanvasLayer

@onready var reset_button : Button = $Panel/Reset

# Called when the node enters the scene tree for the first time.
func _ready():
	hide() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_reset_pressed():
	hide()
	get_tree().paused = false# Replace with function body.
	get_tree().reload_current_scene()
	


func _on_quit_pressed():
	get_tree().paused = false# Replace with function body.
	transition.transition_to("res://main.tscn")


func _on_resume_pressed():
	hide()
	get_tree().paused = false# Replace with function body.
	

