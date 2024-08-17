extends Node2D

@export var move_speed : float = 0.1
@export var move_target : Node2D

func _process(delta):
	var dir = move_target.position - self.position 
	self.position += dir.normalized() * move_speed * delta
