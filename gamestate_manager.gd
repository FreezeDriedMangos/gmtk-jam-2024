class_name GamestateManager extends Node
# handles global requests from other objects
@export var all_entities : Array[Entity]
@export var tooth_mech : ToothMech
@export var tooth_fairy : ToothFairy
@export var cthonic_clients : Array[CthonicClient]
@export var minor_horrors : Array[MinorHorror]


@export var paused : bool
@export var damage_tick_size_ms : int = 1000 #one second

var last_damage_tick: int

func _ready():
	last_damage_tick = Time.get_ticks_msec()
	return

func register_entity(entity:Entity):
	if(entity == null):
		return

	if(entity is CthonicClient):
		cthonic_clients.append(entity)
	elif(entity is MinorHorror):
		minor_horrors.append(entity)
	elif(entity is ToothFairy):
		tooth_fairy = entity
	elif(entity is ToothMech):
		tooth_mech = entity

	all_entities.append(entity)

func kill_entity(entity:Entity):
	all_entities.erase(entity)
	entity.queue_free()

func apply_damage(damage:int, hit_entity:Entity, attacker:Entity):
	hit_entity.take_damage(damage)

func is_paused():
	return paused


func _process(delta):
	if paused:
		return
	if tooth_fairy == null:
		#print("Waiting for tooth fairy to register...")
		return
	if tooth_mech == null:
		#print("Waiting for tooth mech to register...")
		return
	if minor_horrors.size() == 0:
		#print("Waiting for horrors to register...")
		return

	# update tick-based things like DPS -- this will be fine and
	## only execute once when the game unpauses (rather than damage accumulating over the pause period)
	var damage_tick = false
	var current_ms = Time.get_ticks_msec()
	if current_ms - last_damage_tick > damage_tick_size_ms:
		damage_tick = true
		last_damage_tick = current_ms

	#handle "collisions"
	var i = 0

	for horror in minor_horrors:
		i+=1
		if horror == null:
			minor_horrors.remove_at(i)
			continue

		if horror.position.distance_to(tooth_fairy.position) < (horror.radius + tooth_fairy.radius):
			apply_damage(100, horror, tooth_fairy)

		if horror.position.distance_to(tooth_mech.position) < (horror.radius + tooth_mech.radius):
			if !horror.latched:
				horror.latch()
			else:
				if damage_tick:
					apply_damage(horror.damage_per_second, tooth_mech, horror)

		else:
			if horror.latched:
				horror.unlatch()
