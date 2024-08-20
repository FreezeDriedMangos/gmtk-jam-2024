class_name Entity extends Node3D
#base entity class for all things in the game that can die and otherwise factor into gameplay
@export var health:int = 100
@export var radius:float = 1.0
@export var base_move_speed : float = 1.0
@export var collider_area:Area3D

var paused:bool

func _ready():
	GamestateManagerGlobal.register_entity(self)

func die():
	GamestateManagerGlobal.kill_entity(self)

func take_damage(damage:int):
	health -= damage
	if(health < 0):
		die()

func is_game_paused():
	return GamestateManagerGlobal.is_paused()
