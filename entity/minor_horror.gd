@tool class_name MinorHorror extends Entity

@export var move_target : Vector3
@export var latched : bool #whether or not the horror has latched onto the mech
@export var damage_per_second : int #the number of points of damage per second applied to the tooth_mech

@export var tooth_fairy : ToothFairy
@export var tooth_mech : ToothMech
@export var mesh : MeshInstance3D
@export var drill_rads_sec_default : float = 20.0 
@export var drill_rads_sec_latched : float = 160.0 
@export var drill_rads_sec_current : float = drill_rads_sec_default
@export var rotate_vector = Vector3(0, 0, 1)

func _ready():
	super()
	base_move_speed = 22.0
	radius = 1.0


func _process(delta: float) -> void:
	if tooth_fairy == null:
		tooth_fairy = GamestateManagerGlobal.tooth_fairy
	
	


	if tooth_mech != null && move_target != null:
		move_target = tooth_mech.position
		var dir:Vector3 = move_target - self.position 
		#how hard we will try to get to the mech as a function of our distance from it
		var desire:float = clampf(dir.length(), 0, base_move_speed/4) 
		##self.position += dir * desire * delta

		#we'll only worry about rotating the mesh if our target is there
		if mesh != null:
			var rotation_dt = drill_rads_sec_current * delta
			mesh.rotation_degrees += dir.normalized() * rotation_dt
	
	if tooth_mech == null:
		tooth_mech = GamestateManagerGlobal.tooth_mech
	elif move_target == null:
		move_target = tooth_mech.position
		

func get_tooth_mech():
	return GamestateManagerGlobal.get_tooth_mech()

func latch():
	latched = true
	drill_rads_sec_current = drill_rads_sec_latched
func unlatch():
	latched = false
	drill_rads_sec_current = drill_rads_sec_default

func die():
	super()
	print('DIED')
