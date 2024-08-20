class_name Entity extends CharacterBody3D
#base entity class for all things in the game that can die and otherwise factor into gameplay
@export var health:int = 100
@export var radius:float = 1.0
@export var base_move_speed : float = 1.0
@export var collider_area:Area3D
@export var default_sprite: Node3D
@export var queasy_sprite: Node3D
var queasy_mode_enabled: bool

var paused:bool

func _ready():
	GamestateManagerGlobal.register_entity(self)

func _physics_process(delta: float):
	self.position += self.velocity*delta

func die():
	GamestateManagerGlobal.kill_entity(self, null)

func take_damage(damage:int)->bool:
	health -= damage
	if(health <= 0):
		return true
	else:
		return false

func is_game_paused():
	return GamestateManagerGlobal.is_paused()

func set_queasy(queasy):
	queasy_mode_enabled = queasy

	if default_sprite and queasy_sprite:
		default_sprite.set_visible(not queasy_mode_enabled)
		queasy_sprite.set_visible(queasy_mode_enabled)
		
		print(self.name)
		print(queasy_mode_enabled)
		print(default_sprite.visible)
		print(queasy_sprite.visible)
