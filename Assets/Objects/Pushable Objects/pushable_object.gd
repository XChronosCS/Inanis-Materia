extends RigidBody2D

'''
Breakdown of process:
	1) Detect if player has Earth Power obtained. If no, then cannot be pushed. Object is locked in place
	2) If yes, then check for player input for interaction press using Interaction_Area
	3) while interaction input is being held, object can be pushed
	4) When interaction input is no longer being held, object is frozen once again.



'''

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite2D


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	

func _input(event):
	if event.is_action_released("interact"):
		if freeze == false:
			freeze = true
	

func _on_interact():
	if freeze == true:
		freeze = false

