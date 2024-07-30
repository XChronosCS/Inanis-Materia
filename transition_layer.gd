extends CanvasLayer

@onready var screen_transition = $SceneTransitionRect


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func transition_to(target: String) -> void:
	show()
	screen_transition.transition_to(target)



func _on_scene_transition_rect_finished_transition():
	hide()
