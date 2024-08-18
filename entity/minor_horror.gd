class_name MinorHorror extends Entity

@export var move_target : Node3D
@export var latched : bool #whether or not the horror has latched onto the mech
@export var damage_per_second : int #the number of points of damage per second applied to the tooth_mech

@export var tooth_fairy : ToothFairy
@export var tooth_mech : ToothMech

func _ready():
	super()
	base_move_speed = 22.0
	if tooth_fairy == null:
		tooth_fairy = GamestateManagerGlobal.tooth_fairy
	if tooth_mech == null:
		tooth_mech = GamestateManagerGlobal.tooth_mech

func _process(delta: float) -> void:
	
	var dir = move_target.position - self.position 
	self.position += dir.normalized() * base_move_speed * delta

func get_tooth_mech():
	return GamestateManagerGlobal.get_tooth_mech()

func latch():
	latched = true
func unlatch():
	latched = false
