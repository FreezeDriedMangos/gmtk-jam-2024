extends MarginContainer

@export var cthonic_client : CthonicClient
var camera : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	if cthonic_client == null:
		cthonic_client = get_node("../..")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bar_position := camera.unproject_position(cthonic_client.get_node("HealthbarPosition").global_position)
	var vp_size = get_viewport().get_visible_rect().size
	var ratio: Vector2 = (bar_position - vp_size/2) / vp_size

	if abs(ratio.x) > 1 or abs(ratio.y) > 1:
		if abs(ratio.x) > abs(ratio.y):
			bar_position = (bar_position - vp_size/2) / abs(ratio.x) + vp_size/2
		elif ratio.y != 0:
			bar_position = (bar_position - vp_size/2) / abs(ratio.y) + vp_size/2

	position = Vector2(clamp(bar_position.x, size.x*scale.x/2, vp_size.x - size.x*scale.x/2) - size.x*scale.x/2, clamp(bar_position.y, 0, vp_size.y))
	$Bar.value = cthonic_client.health
