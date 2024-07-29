extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var camera = $Camera2D
@export var camera_constraints: Array[int] = []
@onready var anim = $AnimationPlayer
@onready var recent_action = "None"
@onready var pushing_animation: bool = false
@onready var jumping_animation: bool = false
@onready var fire_animation: bool = false # Checks if Inanis is in the middle of the fire animation
@onready var water_animation: bool = false
@onready var airborne: bool = false # Checks to see if protagonist is in the air
@onready var heading_towards_ground: bool = false # Checks to see if the protagonist is heading towards the ground
@onready var is_flipped: bool = false
@onready var air_current_animation: bool = false
@onready var unskippable_animation: bool = false # Flag for when any of the animations I want to play fully are performed. Combinees several flags into one

func _ready():
	camera.limit_bottom = camera_constraints[0]
	camera.limit_left = camera_constraints[1] 
	camera.limit_right = camera_constraints[2]
	camera.limit_top = camera_constraints[3]
	
	
func _physics_process(delta): 
	
	if air_current_animation or fire_animation or jumping_animation or water_animation:
		unskippable_animation = true
	else:
		unskippable_animation = false 
	
	# Prevents Moving during specific parts of the game, such as dialogue boxes
	if not DataSave.flags.prevent_player_movement:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			
			
		if pushing_animation:
			anim.play("Push")
			
		if Input.is_action_pressed("Fire Power"):
			if DataSave.flags.fire_power_usable:
				fire_animation = true
				anim.play("Burn")
		
		if Input.is_action_pressed("Water Power"):
			if DataSave.flags.water_power_usable:
				water_animation = true
				anim.play("Fill")

		# Handle jump. Requires Air Power
		if DataSave.flags.has_air_power:
			# Prevents jump during pushing animation
			if Input.is_action_just_pressed("jump") and is_on_floor() and not pushing_animation: 
				airborne = true
				jumping_animation = true
				anim.play("Jump")
				await get_tree().create_timer(0.2).timeout
				velocity.y = JUMP_VELOCITY
				jumping_animation = false
			if air_current_animation:
				anim.play("Rise")
				
			

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		
		# Controls Momentum
		if direction and not fire_animation and not water_animation: 
				velocity.x = direction * SPEED
				if pushing_animation: # Slows down player when pushing
					velocity.x = direction * SPEED / 2
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
					
		if not pushing_animation: # Makes sure the sprite stays the same orientation when pushing and pulling mechanics are applied
			#Flips direction of sprites depending on input 
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

			if direction:
				if velocity.y == 0 && not airborne && not unskippable_animation: 
					anim.play("Run")
			else:
				if velocity.y == 0 && not airborne && not unskippable_animation:
					anim.play("Idle")
		 
		if velocity.y > 0 && not air_current_animation:
			anim.play("Fall")
			heading_towards_ground = true
		if velocity.y == 0 && heading_towards_ground:
			anim.play("Land")
			await get_tree().create_timer(0.2).timeout
			velocity.x = move_toward(velocity.x, 0, SPEED)
			airborne = false
			heading_towards_ground = false

		move_and_slide()
	else:
		anim.play("Idle")
		


func _on_area_2d_body_entered(body): # Allows Standing on Pushable Objects
	if body.is_in_group("PushableObjects"):
		body.collision_mask = 1


func _on_area_2d_body_exited(body): # Allows STanding on Pushable Objects
	if body.is_in_group("PushableObjects"):
		body.collision_mask = 2
		
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Burn":
		fire_animation = false
		DataSave.flags.fire_power_activated = false
	if anim_name == "Fill":
		water_animation = false
		DataSave.flags.water_power_activated = false
		

		
