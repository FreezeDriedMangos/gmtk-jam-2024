class_name GamestateManager extends Node
# handles global requests from other objects
@export var all_entities : Array[Entity]
@export var tooth_mech : ToothMech
@export var tooth_fairy : ToothFairy
@export var cthonic_clients : Array[CthonicClient]
@export var minor_horrors : Array[MinorHorror]

func _ready():
	return

func register_entity(entity:Entity):
	if(entity == null):
		return

	if(entity is CthonicClient):
		cthonic_clients.append(entity)
	elif(entity is MinorHorror):
		minor_horrors.append(entity)

	all_entities.append(entity)

func kill_entity(entity:Entity):
	entity.queue_free()


	
	
