extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
@onready var recent_action = "None"
@onready var earth_power: bool = false # Governs possession of Earth Power
@onready var air_power: bool = false # Governs possession of Air Power
@onready var fire_power: bool = false # Governs possession of Fire Power
@onready var water_power: bool = false #Governs possession of Water Power
@onready var pushing_animation: bool = false

func _ready():
	pass
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		

	# Handle jump. Requires Air Power
	if air_power:
		# Prevents jump during pushing animation
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not pushing_animation: 
			velocity.y = JUMP_VELOCITY
			anim.play("Jump")
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if not pushing_animation: # Makes sure the sprite stays the same orientation when pushing and pulling mechanics are applied
		#Flips direction of sprites depending on input
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
		if direction == 1:
			get_node("AnimatedSprite2D").flip_h = false
	if direction: 
		velocity.x = direction * SPEED
		if pushing_animation: # Slows down player when pushing
			velocity.x = direction * SPEED / 2
		if velocity.y == 0: 
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
	if velocity.y > 0:
		anim.play("Fall")

	move_and_slide()


func _on_area_2d_body_entered(body): # Allows Standing on Pushable Objects
	if body.is_in_group("PushableObjects"):
		body.collision_layer = 1
		body.collision_mask = 1


func _on_area_2d_body_exited(body): # Allows STanding on Pushable Objects
	if body.is_in_group("PushableObjects"):
		body.collision_layer = 2
		body.collision_mask = 2
		
	
