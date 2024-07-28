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
@onready var moveable: bool = false # Determines if the object is movable or not
@onready var being_pushed: bool = false
@onready var player: CharacterBody2D = null



func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	

func _physics_process(delta):
	if being_pushed == true:
		collision_layer = 2
		if player.position.x < position.x:
			if player.velocity.x < 0:
				set_axis_velocity(Vector2(player.velocity.x * 3, 0))
		if player.position.x > position.x:
			if player.velocity.x > 0:
				set_axis_velocity(Vector2(player.velocity.x * 3, 0))
	else:
		collision_layer = 1
		
		
func _on_interact():
	if DataSave.flags.has_earth_power:
		interaction_area.interaction_disabled = not interaction_area.interaction_disabled
		if being_pushed == false:
			being_pushed = true
			player.pushing_animation = true
			DataSave.flags.earth_power_activated = true
		else:
			being_pushed = false
			player.pushing_animation = false
			DataSave.flags.earth_power_activated = false
			
			
		


func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		player = body
		if DataSave.flags.has_earth_power:
			interaction_area.interaction_disabled = false
			DataSave.flags.earth_power_usable = true


func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		player = body
		interaction_area.interaction_disabled = true
		collision_layer = 1
		player.pushing_animation = false
		DataSave.flags.earth_power_usable = false
		DataSave.flags.earth_power_activated = false
		being_pushed = false

