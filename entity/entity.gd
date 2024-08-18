class_name Entity extends Node3D
#base entity class for all things in the game that can die and otherwise factor into gameplay
@export var health:int
var paused:bool

func die():
	GamestateManagerGlobal.kill_entity(self)

func take_damage(damage:int):
	health -= damage
	if(health < 0):
		die()

func pause():
	paused = true
	return

func unpause():
	paused = false
	return