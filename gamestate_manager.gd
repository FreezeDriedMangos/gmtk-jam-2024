class_name GamestateManager extends Node
# handles global requests from other objects
@export var all_entities : Array[Entity]
@export var tooth_mech : ToothMech
@export var camera : Camera3D
@export var tooth_fairy : ToothFairy
@export var cthonic_clients : Array[CthonicClient]
@export var minor_horrors : Array[MinorHorror]
@export var coin_projectiles : Array[CoinProjectile]

var despawn_array:Array[Entity]

@export var paused : bool
@export var damage_tick_size_ms : int = 1000 #one second
@export var horror_spawn_interval_ms : int = 2000 #one second

var last_damage_tick: int
var last_horror_spawn_tick: int

var internal_queasy: bool = false
@export var queasy_mode_enabled: bool:
	get:
		return internal_queasy
	set(value):
		internal_queasy = value
		print("setting quasy %s" % value)
		for entity in self.all_entities:
			entity.set_queasy(value)

		if get_tree().current_scene.get_node('%RegularToothCountSprite') != null:
			get_tree().current_scene.get_node('%RegularToothCountSprite').set_visible(not value)
			get_tree().current_scene.get_node('%QueasyToothCountSprite').set_visible(value)


func _ready():
	last_damage_tick = Time.get_ticks_msec()
	return

var first_register = true
func register_entity(entity:Entity):
	if(entity == null):
		return
	
	if first_register:
		print("first register")
		print("queasy mode %s" % queasy_mode_enabled)
		
		
		first_register = false
		get_tree().current_scene.get_node('%RegularToothCountSprite').set_visible(not queasy_mode_enabled)
		get_tree().current_scene.get_node('%QueasyToothCountSprite').set_visible(queasy_mode_enabled)
		print(get_tree().current_scene.get_node('%RegularToothCountSprite').name)

	entity.set_queasy(queasy_mode_enabled)

	if(entity is CthonicClient):
		cthonic_clients.append(entity)
	elif(entity is MinorHorror):
		minor_horrors.append(entity)
	elif(entity is ToothFairy):
		tooth_fairy = entity
	elif(entity is ToothMech):
		tooth_mech = entity
	elif(entity is CoinProjectile):
		coin_projectiles.append(entity)


	all_entities.append(entity)

func remove_entity(entity:Entity):
	all_entities.erase(entity)
	entity.queue_free()
	despawn_array.append(entity)

func kill_entity(entity:Entity, killer:Entity):
	if(entity is CthonicClient):
		end_game(true)
	elif(entity is MinorHorror):
		if(killer is ToothFairy):
			killer.teeth += 1
		minor_horrors.erase(entity)
		remove_entity(entity)
	elif(entity is ToothFairy):
		end_game(false)
	elif(entity is ToothMech):
		end_game(false)
	elif(entity is CoinProjectile):
		coin_projectiles.erase(entity)
		remove_entity(entity)


func apply_damage(damage:int, hit_entity:Entity, attacker:Entity):
	#slightly opaque: take_damage applies damage and returns 'true' if the entity dies as a result
	if hit_entity.take_damage(damage):
		kill_entity(hit_entity, attacker)


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

	var spawn_tick:bool = false



	# update tick-based things like DPS -- this will be fine and
	## only execute once when the game unpauses (rather than damage accumulating over the pause period)
	var damage_tick = false
	var current_ms = Time.get_ticks_msec()
	if current_ms - last_damage_tick > damage_tick_size_ms:
		damage_tick = true
		last_damage_tick = current_ms

	#
	#handle "collisions"
	#



	var i = 0
	for horror in minor_horrors:
		i+=1
		if horror == null:
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

func end_game(win:bool = false):
	return
