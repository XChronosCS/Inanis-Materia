extends State

@export var ground_state: State

func on_enter():
	character.death_flag = false


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Death":
		character.respawn()
		next_state = ground_state
		playback.travel("Move")
