extends MarginContainer

@export var cthonic_client : CthonicClient
var camera : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !camera:
		if cthonic_client:
			camera = cthonic_client.camera_that_wont_leave_like_dad
		else: 
			return

	var bar_position := camera.unproject_position(cthonic_client.get_node("HealthbarPosition").global_position)
	var vp_size = get_viewport().get_visible_rect().size

	position = Vector2(clamp(bar_position.x - size.x*scale.x/2, 0, vp_size.x), clamp(bar_position.y, 0, vp_size.y))
	$Bar.value = cthonic_client.health
