extends Timer

@onready var coyote_frames = 6
@onready var coyote = false
@onready var last_floor = false # Last frame's on-floor state



func _on_timeout():
	coyote = false # Replace with function body.
