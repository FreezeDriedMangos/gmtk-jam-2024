@tool class_name MinorHorror extends Entity

@export var move_target : Vector3
@export var latched : bool #whether or not the horror has latched onto the mech
@export var damage_per_second : int = 10 #the number of points of damage per second applied to the tooth_mech

@export var tooth_fairy : ToothFairy
@export var tooth_mech : ToothMech
@export var mesh : MeshInstance3D
@export var drill_rads_sec_default : float = 80.0 
@export var drill_rads_sec_latched : float = 460.0 
@export var drill_rads_sec_current : float = drill_rads_sec_default
@export var rotate_vector = Vector3(0, 0, 1)
@export var moving = true

func _ready():
	super()
	base_move_speed = 22.0
	radius = 1.0

func _physics_process(delta: float) -> void:
	if tooth_fairy == null && GamestateManagerGlobal.tooth_fairy != null:
		tooth_fairy = GamestateManagerGlobal.tooth_fairy
	
	if tooth_mech != null && move_target != null && moving:
		move_target = tooth_mech.position
		var target_relative = (move_target - position)
		#how hard we will try to get to the mech as a function of our distance from it.
		var desire:float = clampf(target_relative.length_squared(), 0.0, base_move_speed/2.0) 

		position += target_relative.normalized() * delta * desire

	#we'll only worry about rotating the mesh if our target is there and we have a mesh to speen
	if mesh != null:
		var rotation_dt:float = drill_rads_sec_current * delta
		mesh.rotation_degrees += Vector3(rotation_dt, 0, rotation_dt*0.5)
	
	if tooth_mech == null:
		tooth_mech = get_tooth_mech()
	elif move_target == null:
		move_target = tooth_mech.position

	if latched:
		drill_rads_sec_current = drill_rads_sec_latched
	else: 
		drill_rads_sec_current = drill_rads_sec_default

		

func get_tooth_mech():
	return GamestateManagerGlobal.tooth_mech

func latch():
	print('LATCHED')
	latched = true
	moving = false
	
func unlatch():
	latched = false
	moving = true

func die():
	super()
	print('DIED')
