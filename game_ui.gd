extends CanvasLayer


@onready var pause_menu = $PauseMenu
# Called when the node enters the scene tree for the first time.

func _ready():
	pause_menu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed('pause'):
		pause_menu.show()
		get_tree().paused = true 
