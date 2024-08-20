class_name ToothMech extends Entity

@export var target:Entity
@export var target_locator:Node3D
@export var rumble:AudioStreamPlayer3D
@export var camera:Camera3D

const CANNON_DEGREES_TURN_PER_SECOND = 30

var walking
var firing = false
var firing_interval_ms = 60
var last_shot_ms = 0.0

var mouseScreenPos = Vector2()

var wad_projectile_resource = preload("res://entity/wad_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	base_move_speed = 0.1
	radius = 10
	pass # Replace with function body.

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if event.button_index == 1:
			firing = event.pressed
	if event is InputEventKey:
		if event.as_text() == 'w':
			walking = true

	elif event is InputEventMouseMotion:
		mouseScreenPos = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_down", "ui_up"))

func _physics_process(delta: float) -> void:
	var turn_amt = deg_to_rad(CANNON_DEGREES_TURN_PER_SECOND) * delta
	var cannon := $Cannon as Node3D
	var target_pos := Vector2(target.global_position.x, target.global_position.y)
	var cannon_pos := Vector2(cannon.global_position.x, cannon.global_position.y)
	var angle := (target_pos - cannon_pos).angle()
	var angle_diff: float = angle_difference(angle, cannon.global_rotation.y)
	var angle_delta: float = -clamp(angle_diff, -turn_amt, turn_amt)

	cannon.global_rotation.y += angle_delta

func raycast_from_mouse():
	var ray_start = camera.project_ray_origin(mouseScreenPos)
	var ray_end = ray_start + camera.project_ray_normal(mouseScreenPos) * 1000
	var world3d : World3D = get_world_3d()
	var space_state = world3d.direct_space_state

	if space_state == null:
		return

	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	return result["position"]
