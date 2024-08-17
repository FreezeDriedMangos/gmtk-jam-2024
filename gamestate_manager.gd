class_name GamestateManager extends Node
# handles global requests from other objects
@export var all_entities : Node2D
@export var tooth_mech : ToothMech
@export var tooth_fairy : ToothFairy
@export var cthonic_clients : CthonicClient
@export var minor_horrors : MinorHorror

func _ready():
    tooth_mech