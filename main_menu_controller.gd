extends Node

@export var sprite_none_selected: Node
@export var sprite_left_selected: Node
@export var sprite_right_selected: Node
@export var sprite_left_clicked: Node

var starting_game = false

var queasy_mode = false

func start_game():
	disable_all_sprites()
	sprite_left_clicked.set_visible(true)
	starting_game = true
	print("Game starting!")
	
	if not queasy_mode:
		%TeethMenu.get_goin()
	else:
		get_tree().change_scene_to_file("res://physical_battle_environment.tscn")

func toggle_queasy():
	if starting_game:
		return
	
	queasy_mode = not queasy_mode
	print("toggling queasy")
	GamestateManagerGlobal.queasy_mode_enabled = queasy_mode
	
	if queasy_mode:
		%QueasyMenu.set_visible(true)
		%TeethMenu.set_visible(false)
	else:
		%QueasyMenu.set_visible(false)
		%TeethMenu.set_visible(true)

func hover_left():
	if starting_game:
		return
	
	hovered_left = true
	disable_all_sprites()
	sprite_left_selected.set_visible(true)

func hover_right():
	if starting_game:
		return
	
	hovered_right = true
	disable_all_sprites()
	sprite_right_selected.set_visible(true)

var hovered_right = false
func unhover_right():
	if starting_game:
		return
	
	hovered_right = false
	if not hovered_left:
		disable_all_sprites()
		sprite_none_selected.set_visible(true)

var hovered_left = false
func unhover_left():
	if starting_game:
		return
	
	hovered_left = false
	if not hovered_right:
		disable_all_sprites()
		sprite_none_selected.set_visible(true)

func disable_all_sprites():
	sprite_none_selected.set_visible(false)
	sprite_left_selected.set_visible(false)
	sprite_right_selected.set_visible(false)
	sprite_left_clicked.set_visible(false)

func close_modal():
	%QueasyModal.set_visible(false)
