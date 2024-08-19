extends MarginContainer

@export var client : CthonicClient

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera: Camera3D = %Camera3D
	var bar_position := camera.unproject_position(client.get_node("HealthbarPosition").global_position)
	var vp_size = get_viewport().get_visible_rect().size

	position = Vector2(clamp(bar_position.x - size.x*scale.x/2, 0, vp_size.x), clamp(bar_position.y, 0, vp_size.y))
	$Bar.value = client.health
