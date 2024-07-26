extends CanvasLayer

# Called when the node enters the scene tree for the first time.

@onready var air_power_state = DataSave.flags.has_air_power
@onready var earth_power_state = DataSave.flags.has_earth_power
@onready var fire_power_state = DataSave.flags.has_fire_power
@onready var water_power_state = DataSave.flags.has_water_power
@onready var earth_power = $EarthSymbol
@onready var air_power = $AirSymbol
@onready var fire_power = $FireSymbol
@onready var water_power = $WaterSymbol

func _ready():
	if air_power_state:
		air_power.play("Symbol On")
	else:
		air_power.play("Symbol Off")
	if earth_power_state:
		earth_power.play("Symbol On")
	else:
		earth_power.play("Symbol Off")
	if fire_power_state:
		fire_power.play("Symbol On")
	else:
		fire_power.play("Symbol Off")
	if water_power_state:
		water_power.play("Symbol On")
	else:
		water_power.play("Symbol Off")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Air Power Flag checks
	if DataSave.flags.air_power_activated:
		air_power.play("Symbol Active")
	elif DataSave.flags.air_power_usable:
		air_power.play("Symbol Ready")
	elif DataSave.flags.has_air_power:
		air_power.play("Symbol On")
	else:
		air_power.play("Symbol Off")
		
	# Earth Power Flag checks
	if DataSave.flags.earth_power_activated:
		earth_power.play("Symbol Active")
	elif DataSave.flags.earth_power_usable:
		earth_power.play("Symbol Ready")
	elif DataSave.flags.has_earth_power:
		earth_power.play("Symbol On")
	else:
		earth_power.play("Symbol Off")
		
	# Fire Power Flag checks
	if DataSave.flags.fire_power_activated:
		fire_power.play("Symbol Active")
	elif DataSave.flags.fire_power_usable:
		fire_power.play("Symbol Ready")
	elif DataSave.flags.has_fire_power:
		fire_power.play("Symbol On")
	else:
		fire_power.play("Symbol Off")
	
	# Water Power Flag checks
	if DataSave.flags.water_power_activated:
		water_power.play("Symbol Active")
	elif DataSave.flags.water_power_usable:
		water_power.play("Symbol Ready")
	elif DataSave.flags.has_water_power:
		water_power.play("Symbol On")
	else:
		water_power.play("Symbol Off")
	
	
	
	
	
