extends RigidBody2D

'''
Breakdown of process:
	1) Detect if player has Earth Power obtained. If no, then cannot be pushed. Object is locked in place
	2) If yes, then check for player input for interaction press using Interaction_Area
	3) while interaction input is being held, object can be pushed
	4) When interaction input is no longer being held, object is frozen once again.



'''

@onready var interaction_area: InteractionArea = $Pushing_Interaction_Area
@onready var interaction_fire_area: InteractionArea = $Fire_Interaction_Area
@onready var interaction_water_area: InteractionArea = $Water_Interaction_Area
@onready var sprite = $Sprite2DCube
@onready var wind_current = $WindCurrent
@onready var wind_animation = $WindCurrent/AnimatedSprite2D
@onready var moveable: bool = false # Determines if the object is movable or not
@onready var being_pushed: bool = false
@onready var player: CharacterBody2D = null
@export var ground_y = 0
@onready var is_lit: bool = false
@onready var is_filled: bool = false
@onready var has_wind: bool = false
@onready var anim_player = $AnimationPlayer
@onready var playing_animation: String = ""



func _ready(): 
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_fire_area.interact = Callable(self, "_on_fire_interact")
	interaction_water_area.interact = Callable(self, "_on_water_interact")
	wind_current.visible = false
	wind_current.process_mode = Node.PROCESS_MODE_DISABLED
	


@warning_ignore("unused_parameter")
func _process(delta):
	if not has_wind:
		if is_filled and is_lit:
			wind_current.visible = true
			wind_current.process_mode = Node.PROCESS_MODE_INHERIT
			wind_animation.play("Wind Current")
			has_wind = true
	
	# Tree for Playing Animations
	if is_filled:
		if is_lit:
			anim_player.play("Boiling")
		else:
			pass
	elif is_lit:
		anim_player.play("Burning")
	else:
		anim_player.play("Default")

			
		
	
@warning_ignore("unused_parameter")
func _physics_process(delta):
	if being_pushed == true:
		collision_layer = 2
		ground_y = player.position.y
		position.y = ground_y - 25
		if player.position.x < position.x:
			if player.velocity.x < 0:
				linear_velocity.x = player.velocity.x * 2
			elif not Input.is_action_pressed("move_right"):
				linear_velocity.x = 0
			elif Input.is_action_pressed("move_right"):
				linear_velocity.x = player.SPEED / 2
		if player.position.x > position.x:
			if player.velocity.x > 0:
				linear_velocity.x = player.velocity.x * 2
			elif not Input.is_action_pressed("move_left"):
				linear_velocity.x = 0
			elif Input.is_action_pressed("move_left"):
				linear_velocity.x = -player.SPEED / 2
			
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
			linear_velocity.y = 0
			
			
		
func _on_water_interact():
	print("Water Interact Trigger")
	interaction_water_area.interaction_disabled = not interaction_water_area.interaction_disabled
	DataSave.flags.water_power_activated = true
	anim_player.play("Filled")
	is_filled = true
	
func _on_fire_interact():
	print("Fire Interact Triggered")
	interaction_fire_area.interaction_disabled = not interaction_fire_area.interaction_disabled
	DataSave.flags.fire_power_activated = true
	is_lit = true
	
	

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



func _on_water_interaction_area_body_entered(body):
	if body.name == "Player":
		if DataSave.flags.has_water_power && not is_filled:
			interaction_water_area.interaction_disabled = false
			DataSave.flags.water_power_usable = true

func _on_water_interaction_area_body_exited(body):
	if body.name == "Player":
		interaction_water_area.interaction_disabled = true
		DataSave.flags.water_power_usable = false
		DataSave.flags.water_power_activated = false


func _on_fire_interaction_area_body_entered(body):
	if body.name == "Player":
		if DataSave.flags.has_fire_power && not is_lit:
			interaction_fire_area.interaction_disabled = false
			DataSave.flags.fire_power_usable = true 


func _on_fire_interaction_area_body_exited(body):
	if body.name == "Player":
		interaction_fire_area.interaction_disabled = true
		DataSave.flags.fire_power_usable = false
		DataSave.flags.fire_power_activated = false # Replace with function body.
