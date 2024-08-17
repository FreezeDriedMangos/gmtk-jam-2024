class_name CthonicClient extends Entity

@export var move_speed : float = 0.1
@export var move_target : Node3D

func _process(delta: float) -> void:
	var dir = move_target.position - self.position 
	self.position += dir.normalized() * move_speed * delta
