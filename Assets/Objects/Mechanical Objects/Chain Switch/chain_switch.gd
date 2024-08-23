extends Node2D

@onready var pullable_object = $RigidBody2D
@onready var interaction_area = $RigidBody2D/InteractionAreaCube
@export var scene: Node2D
signal openTheGates
@onready var chain_being_moved: bool = false
@export var chain: RigidBody2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_trigger_zone_body_entered(_body):
	if chain_being_moved:
		chain.stop_chain()
		chain.linear_velocity.x = 0
		chain.linear_velocity.y = 0
		openTheGates.emit()
		audio.play()
		InteractionManager.unregister_area(interaction_area)
		chain.process_mode = Node.PROCESS_MODE_DISABLED
		interaction_area.queue_free()
		chain_being_moved = false




func _on_rigid_body_2d_chain_picked_up():
	chain_being_moved = true


func _on_rigid_body_2d_chain_released():
	chain_being_moved = false
