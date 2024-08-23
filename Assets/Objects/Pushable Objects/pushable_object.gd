extends RigidBody2D

'''
Breakdown of process:
	1) Detect if player has Earth Power obtained. If no, then cannot be pushed. Object is locked in place
	2) If yes, then check for player input for interaction press using Interaction_Area
	3) while interaction input is being held, object can be pushed
	4) When interaction input is no longer being held, object is frozen once again.



'''

@onready var interaction_area: InteractionArea = $InteractionAreaCube
@onready var sprite = $Sprite2DCube
@onready var moveable: bool = false # Determines if the object is movable or not
@onready var being_pushed: bool = false
@export var player: CharacterBody2D = null
@export var scene: Node2D = null
@export var ground_y = 0
@onready var psm = PowerStateMachine



func _ready(): 
	interaction_area.interact = Callable(self, "_on_interact")
	
	

func _physics_process(_delta):
	pass
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
		
		
		
func _on_interact():
	if psm.current_power.alchemical_power == "Earth":
		# When the parent of the pushable block is the player, it moves alongside the player. 
		if get_parent() == player:
			reparent(scene)
			set_collision_mask_value(2, true)
		else:
			reparent(player)
			set_collision_mask_value(2, false)

			
	# Old Code
		#if being_pushed == false:
			#being_pushed = true
			#player.pushing_animation = true
			#DataSave.flags.earth_power_activated = true
		#else:
			#being_pushed = false
			#player.pushing_animation = false
			#DataSave.flags.earth_power_activated = false
			#linear_velocity.y = 0
			
			
		


func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		pass


func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		psm.power_in_use = false
		set_collision_mask_value(2, true)
		if player.state_machine.current_state.name == "Pushing":
			player.state_machine.current_state.force_move()
			call_deferred("reparent", scene)

