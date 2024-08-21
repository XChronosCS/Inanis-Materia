extends Area2D
class_name InteractionArea

@export var power_needed: String = "None"

var interact: Callable = func():
	pass


func _on_body_entered(body): 
	if body.name == "Player":
		InteractionManager.register_area(self)



func _on_body_exited(body):
	if body.name == "Player":
		InteractionManager.unregister_area(self)
