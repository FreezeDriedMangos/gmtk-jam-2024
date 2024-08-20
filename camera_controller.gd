class_name CameraController extends Camera3D

# needs two modes: tracking mech and tracking fairy
# needs to be able to transition between those modes
# tracking code should be essentially the same, the only difference being the offset from the target object

@export var followed_entity:Entity

@export var fairy_follow_speed: float = 0.3
@export var fairy_follow_rotation_speed: float = 0.6
@export var fairy_target: Node3D

@export var followed_tooth_fairy:ToothFairy
@export var followed_tooth_mech:ToothMech

var mouseScreenPos = Vector2()

@export var height = 17.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event):
	# Mouse in viewport coordinates.

	# handle player input to the fairy
	if followed_entity is ToothFairy:
		followed_tooth_fairy = (followed_entity as ToothFairy)
		if event is InputEventMouseButton:
			#print("Mouse Click/Unclick at: ", event.position)
			if event.button_index == 1:
				followed_tooth_fairy.boosting = event.pressed
			elif event.button_index == 2:
				followed_tooth_fairy.firing = event.pressed
		elif event is InputEventMouseMotion:
			mouseScreenPos = event.position
			
	elif followed_entity is ToothMech:
		followed_tooth_mech = (followed_entity as ToothMech) 
		if event is InputEventKey:
			print(event.as_text())
			if event.as_text() == 'w':
				followed_tooth_mech.walking = event.pressed
			elif event is InputEventMouseMotion:
				mouseScreenPos = event.position
				followed_tooth_mech.desired_direction = Vector3(mouseScreenPos.x, 0, mouseScreenPos.y)

	# handle player input to the mech


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if followed_entity is ToothFairy:
		self.position = followed_entity.position + 0.15*followed_entity.velocity + Vector3(0, height, 0)
	elif followed_entity is ToothMech:
		self.position = followed_entity.position + 5*followed_entity.velocity + Vector3(0, height, 0)

func raycast_from_mouse():
	var ray_start = project_ray_origin(mouseScreenPos)
	var ray_end = ray_start + project_ray_normal(mouseScreenPos) * 1000
	var world3d : World3D = get_world_3d()
	var space_state = world3d.direct_space_state

	if space_state == null:
		return

	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	return result["position"]