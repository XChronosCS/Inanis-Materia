extends Node2D

@onready var jump_sign = $JumpControlsSign


# Called when the node enters the scene tree for the first time.
func _ready():
	jump_sign.play("Not Visible")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_elemental_powers_body_entered(body):
	jump_sign.play("Sign Appears") # Replace with function body.
