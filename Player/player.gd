extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var camera = $Camera2D
@export var camera_constraints: Array[int] = []
@onready var anim = $AnimationPlayer
# @onready var recent_action = "None"
# @onready var pushing_animation: bool = false
# @onready var jumping_animation: bool = false
@onready var fire_animation: bool = false # Checks if Inanis is in the middle of the fire animation
@onready var water_animation: bool = false
@onready var airborne: bool = false # Checks to see if protagonist is in the air
@onready var heading_towards_ground: bool = false # Checks to see if the protagonist is heading towards the ground
@onready var is_flipped: bool = false
@onready var air_current_animation: bool = false
@onready var unskippable_animation: bool = false # Flag for when any of the animations I want to play fully are performed. Combinees several flags into one
@onready var melt_animation: bool = false
@onready var landing = false
@onready var audio_player = $AudioStreamPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var death_flag: bool = false

# Death Details
@onready var starting_position_x = 0
@onready var starting_position_y = 0


func _ready():
	anim_tree.active = true
	starting_position_x = position.x
	starting_position_y = position.y
	camera.limit_bottom = camera_constraints[0]
	camera.limit_left = camera_constraints[1] 
	camera.limit_right = camera_constraints[2]
	camera.limit_top = camera_constraints[3]
	coyote_timer.wait_time = coyote_timer.coyote_frames / 60.0
	
	
func end_powers():
		#water_animation = false
		#fire_animation = false
		#pushing_animation = false
		#air_current_animation = false
		#melt_animation = false
		#DataSave.flags.fire_power_activated = false
		#DataSave.flags.earth_power_activated = false
		#DataSave.flags.air_power_activated = false
		#DataSave.flags.water_power_activated = false
		pass
		
		
func respawn():
	position.x = starting_position_x
	position.y = starting_position_y
func movement_anim_handler():
	var direction = Input.get_vector("move_left", "move_right", "jump", "move_down")
	anim_tree.set("parameters/Move/blend_position", direction.x)
				

func orientation_handler():
	var direction = Input.get_axis("move_left", "move_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
		if not is_flipped:
			get_node("CollisionShape2D").position.x *= -1
			is_flipped = true	
	if direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		if is_flipped:
			get_node("CollisionShape2D").position.x *= -1
			is_flipped = false
		
				
#func jump():
	#airborne = true
	#jumping_animation = true
	## await get_tree().create_timer(0.2).timeout
	#velocity.y = JUMP_VELOCITY
	#jumping_animation = false
	
func _input(event):
	if event.is_action_released("zoom_in"):
		if camera.zoom.x == 2 && camera.zoom.y == 2:
			pass
		else:
			camera.zoom.x += .5
			camera.zoom.y += .5
	if event.is_action_released("zoom_out"):
		if camera.zoom.x == 1 && camera.zoom.y == 1:
			pass
		else:
			camera.zoom.x -= .5
			camera.zoom.y -= .5
		
func _physics_process(delta): 
	
	if not is_on_floor():
			velocity.y += gravity * delta
			
	# Prevents Moving during specific parts of the game, such as dialogue boxes
	if state_machine.check_can_move():
		# Add the gravity. 
			
		#if pushing_animation and DataSave.flags.earth_power_activated and not water_animation and not fire_animation:
			#anim.play("Push")
			#
		#if Input.is_action_pressed("Fire Power"):
			#if DataSave.flags.fire_power_usable and not pushing_animation:
				#fire_animation = true
				#anim.play("Burn")
		#
		#if Input.is_action_pressed("Water Power"):
			#if DataSave.flags.water_power_usable and not melt_animation and not pushing_animation:
				#water_animation = true
				#anim.play("Fill")
				#
#
		## Handle jump. Requires Air Power
		#if DataSave.flags.has_air_power:
			## Prevents jump during pushing animation
			#pass
				#
			#

		var direction = Input.get_axis("move_left", "move_right")
		
		# Controls Momentum
		if direction:
				velocity.x = direction * SPEED
				if state_machine.current_state.name == "Pushing": # Slows down player when pushing
					velocity.x = direction * SPEED / 2
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
					
		#if not pushing_animation: # Makes sure the sprite stays the same orientation when pushing and pulling mechanics are applied
			##Flips direction of sprites depending on input 
			#if direction == -1:
				#get_node("AnimatedSprite2D").flip_h = true
				#if not is_flipped:
					#get_node("CollisionShape2D").position.x *= -1
					#is_flipped = true
					#
			#if direction == 1:
				#get_node("AnimatedSprite2D").flip_h = false
				#if is_flipped:
					#get_node("CollisionShape2D").position.x *= -1
					#is_flipped = false
#
			#if direction:
				#if velocity.y == 0 && not unskippable_animation: 
					#anim.play("Run")
					#landing = false
			#else:
				#if velocity.y == 0 && not airborne && not unskippable_animation:
					#anim.play("Idle")
					#landing = false
					
		movement_anim_handler()
		if state_machine.current_state.name != "Pushing":
			orientation_handler()
		 
		#if velocity.y > 0 && not air_current_animation:
			#anim.play("Fall")
			#heading_towards_ground = true
		#if velocity.y == 0 && heading_towards_ground:
			#anim.play("Land")
			#landing = true
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			#airborne = false
			#heading_towards_ground = false

		move_and_slide()
		

func character_death():
	death_flag = true
	state_machine.current_state.force_move()

#func _on_animation_player_animation_finished(anim_name):
	#if anim_name == "Burn":
		#end_powers()
	#if anim_name == "Fill":
		#end_powers()
	#if anim_name == "Drain":
		#hide()
	#if anim_name == "Reform":
		#end_powers()
	#if anim_name == "Land":
		#landing = false
		

		

