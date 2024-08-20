extends Node3D

var horror_scene_resource = preload("res://entity/minor_horror.tscn")
var last_spawn_ms = 0
@export var spawn_interval_ms = 2000
var range = 120.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_ms = Time.get_ticks_msec()
	if current_ms - last_spawn_ms > spawn_interval_ms:
		last_spawn_ms = current_ms
		spawn()
	pass

func spawn():
	var horror:MinorHorror = horror_scene_resource.instantiate()
	get_parent().add_child(horror)
	horror.position = Vector3(randf_range(0-range,range), 0, randf_range(0-range,range))
	
