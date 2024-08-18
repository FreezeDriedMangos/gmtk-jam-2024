class_name CthonicClient extends Entity

@export var move_target : Node3D

func _ready():
	super()

func _process(delta: float) -> void:
	base_move_speed = 0.1
	var dir = move_target.position - self.position
	self.position += dir.normalized() * base_move_speed * delta
