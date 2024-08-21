extends CanvasLayer

# Called when the node enters the scene tree for the first time.

@onready var current_power: PowerState = PowerStateMachine.current_power
@onready var previous_power: PowerState = PowerStateMachine.previous_power
@onready var next_power: PowerState = PowerStateMachine.next_power
@onready var earth_power = $EarthSymbol
@onready var air_power = $AirSymbol
@onready var fire_power = $FireSymbol
@onready var water_power = $WaterSymbol
@onready var next_power_display = $NextPower
@onready var prev_power_display = $PreviousPower
@onready var center_sprite = $CenterRing
@onready var controller_sprite = $CenterRingController
@onready var displayed_power: AnimatedSprite2D

func _ready():
	select_power_visibility("Default")
	prev_power_display.play("Default")
	next_power_display.play("Default")

func select_power_visibility(selected_power: String):
	for child in get_children():
		if child.is_in_group("PowerSymbol"):
			if child.name == selected_power + "Symbol":
				child.visible = true
			else:
				child.visible = false
				
func _input(event):
	if event is InputEventKey:
		center_sprite.visible = true
		controller_sprite.visible = false
	elif event is InputEventJoypadButton:
		center_sprite.visible = false
		controller_sprite.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if not PowerStateMachine.powers.is_empty():
		current_power = PowerStateMachine.current_power
		previous_power = PowerStateMachine.previous_power
		next_power = PowerStateMachine.next_power
		next_power_display.play(next_power.alchemical_power)
		prev_power_display.play(previous_power.alchemical_power)
		# Air Power Flag checks
		match current_power.alchemical_power:
			"Earth":
				displayed_power = earth_power
			"Air":
				displayed_power = air_power
			"Fire":
				displayed_power = fire_power
			"Water":
				displayed_power = water_power
		
		select_power_visibility(current_power.alchemical_power)
		
		if displayed_power != null:
			if PowerStateMachine.power_in_use:
				displayed_power.play("Symbol Active")
			elif current_power.alchemical_power in PowerStateMachine.interactable_powers:
				displayed_power.play("Symbol Ready")
			elif current_power.enabled:
				displayed_power.play("Symbol On")
			else:
				displayed_power.play("Symbol Off")
			
	
	
	
	
	
