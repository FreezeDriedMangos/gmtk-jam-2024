extends Node2D

@export var uppers: Node2D
@export var lowers: Node2D

var goin = false
var been_goin_for = 0.0

func get_goin():
	goin = true
	print("goin!")


func _process(delta: float) -> void:
	if not goin:
		return
	
	
	uppers.scale *= 1 + 0.7*delta
	lowers.scale *= 1 + 0.7*delta
	
	uppers.position.y -= 400*delta
	lowers.position.y += 400*delta
	
	been_goin_for += delta
	if been_goin_for >= 2:
		print("done!")
		goin = false
		get_tree().change_scene_to_file("res://physical_battle_environment.tscn")
