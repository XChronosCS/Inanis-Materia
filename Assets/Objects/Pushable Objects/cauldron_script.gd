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
@export var ground_y = 0
@export var is_lit: bool = false
@export var is_filled: bool = false
@onready var has_wind: bool = false
@onready var anim_player = $AnimationPlayer
@onready var playing_animation: String = ""
@onready var psm = PowerStateMachine
@export var player: CharacterBody2D = null
@export var scene: Node2D = null



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
			wind_current.player = player
	
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
	#if being_pushed == true:
		#collision_layer = 2
		#ground_y = player.position.y
		#position.y = ground_y - 25
		#if player.position.x < position.x:
			#if player.velocity.x < 0:
				#linear_velocity.x = player.velocity.x * 2
			#elif not Input.is_action_pressed("move_right"):
				#linear_velocity.x = 0
			#elif Input.is_action_pressed("move_right"):
				#linear_velocity.x = player.SPEED / 2
		#if player.position.x > position.x:
			#if player.velocity.x > 0:
				#linear_velocity.x = player.velocity.x * 2
			#elif not Input.is_action_pressed("move_left"):
				#linear_velocity.x = 0
			#elif Input.is_action_pressed("move_left"):
				#linear_velocity.x = -player.SPEED / 2
			#
	#else:
		#
		#collision_layer = 1
		#
		#
	pass
	
func _on_interact():
	if psm.current_power.alchemical_power == "Earth":
		# When the parent of the pushable block is the player, it moves alongside the player. 
		if get_parent() == player:
			reparent(scene)
			set_collision_mask_value(2, true)
			being_pushed = false
		else:
			reparent(player)
			set_collision_mask_value(2, false)
			being_pushed = true
			
			
		
func _on_water_interact():
	if not being_pushed and psm.current_power.alchemical_power == "Water":
		anim_player.play("Filled")
		is_filled = true
		interaction_water_area.queue_free()
	
func _on_fire_interact():
	if not being_pushed and psm.current_power.alchemical_power == "Fire":
		is_lit = true
		interaction_fire_area.queue_free()
	
	

func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		pass


func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		psm.power_in_use = false
		set_collision_mask_value(2, true)
		being_pushed = false
		if player.state_machine.current_state.name == "Pushing":
			player.state_machine.current_state.force_move()
			call_deferred("reparent", scene)
			



func _on_water_interaction_area_body_entered(body):
	if body.name == "Player":
		pass

func _on_water_interaction_area_body_exited(body):
	if body.name == "Player":
		pass


func _on_fire_interaction_area_body_entered(body):
	if body.name == "Player":
		pass


func _on_fire_interaction_area_body_exited(body):
	if body.name == "Player":
		pass
