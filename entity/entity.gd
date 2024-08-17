class_name Entity extends Node3D
#base entity class for all things in the game that can die and otherwise factor into gameplay

func die():
	GamestateManagerGlobal.kill_entity(self)
