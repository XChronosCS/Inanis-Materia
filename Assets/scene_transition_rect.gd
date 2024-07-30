extends ColorRect

# Path to the next scene to transition to

# Reference to the _AnimationPlayer_ node
@onready var anim_player = $AnimationPlayer
@onready var target_scene = ""
@onready var transitioning_scene = false
signal finished_Transition


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Plays the animation backward to fade in
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func transition_to(target: String) -> void:
	# Plays the Fade animation and wait until it finishes
	transitioning_scene = true
	target_scene = target
	anim_player.play("dissolve")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(target_scene)
	finished_Transition.emit()
	

	

