class_name MinorHorror extends Entity

@export var move_speed : float = 0.1
@export var move_target : Node3D
@export var size : float #radius of circular collider

func _process(delta: float) -> void:
	var dir = move_target.position - self.position 
	self.position += dir.normalized() * move_speed * delta

func get_tooth_mech():
	return GamestateManagerGlobal.get_tooth_mech()
