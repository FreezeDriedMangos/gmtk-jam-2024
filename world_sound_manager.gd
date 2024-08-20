extends AudioStreamPlayer

@export var audio_dictionary:Dictionary = {
	'intro': preload("res://sound/intro.mp3")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	audio_dictionary['idle'] = preload("res://sound/intro.mp3")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
