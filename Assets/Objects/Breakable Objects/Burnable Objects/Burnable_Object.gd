extends StaticBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@export var starting_animation: String = ""
@export var burning_animation: String = ""
@onready var animation = get_node("AnimationPlayer")
@onready var sprite_animation = $AnimatedSprite2D/SpriteAnimationPlayer
@onready var psm = PowerStateMachine


# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	if starting_animation != "":
		animation.play(starting_animation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass

func _on_interact():
	if psm.confirm_power_obtained("Fire"):
		await get_tree().create_timer(0.8).timeout
		sprite_animation.stop()
		if burning_animation != "":	
			animation.play(burning_animation)
			await get_tree().create_timer(1.5).timeout
		queue_free()


func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		if psm.confirm_power_obtained("Fire"):
			sprite_animation.play("Burnable")


func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		animation.play(starting_animation)
