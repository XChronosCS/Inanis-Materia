extends Node2D

@onready var pullable_object = $RigidBody2D
@onready var interaction_area = $RigidBody2D/InteractionAreaCube
signal openTheGates


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_trigger_zone_body_entered(body):
	if body.is_in_group("Chain"):
		pullable_object.linear_velocity.x = 0
		pullable_object.linear_velocity.y = 0
		openTheGates.emit()
		InteractionManager.unregister_area(interaction_area)
		pullable_object.process_mode = Node.PROCESS_MODE_DISABLED
		interaction_area.queue_free()


