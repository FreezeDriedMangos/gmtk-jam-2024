class_name ToothFairy extends Entity

@export var starting_distance = 70
@export var boost_speed: float = 30
@export var strafe_speed: float = 5
@export var tooth_mech: Node3D

@export var velocity = Vector3()
@export var max_friction: float = 1.9
@export var min_friction: float = 0.9
@export var max_turn_speed: float = 0.09

@export var base_fov:float = 5.0
@export var boosting_fov_multiplier:float = 1.5

var facing: float = 0

@export var camera: Camera3D

var boosting = false
var firing = false
var firing_interval_ms = 60
var last_shot_ms = 0.0

var coin_projectile_resource = preload("res://entity/coin_projectile.tscn")

var mouseScreenPos = Vector2()

func _ready() -> void:
	super()
	base_move_speed = 10
	radius = 1
	pass
	#self.position = tooth_mech.position + Vector3(0, 0, -self.starting_distance)
	#self.velocity = Vector3(speed, 0, 0)


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if event.button_index == 1:
			boosting = event.pressed
		elif event.button_index == 2:
			firing = event.pressed
	elif event is InputEventMouseMotion:
		var rect = camera.get_viewport().size
		mouseScreenPos = event.position



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


func _physics_process(delta: float) -> void:
	# zoom out camera a lil when boosting
	#

	if boosting: 
		camera.fov = lerp(camera.fov, base_fov*boosting_fov_multiplier, 4.0*delta)
	else:
		camera.fov = lerp(camera.fov, base_fov, 3.0*delta)
			
		
	#
	# determine desired movement direction
	#

	var mouseWorldPos = raycast_from_mouse()
	var mouseRelPos = mouseWorldPos - self.position

	var desired_dir = Vector3(mouseRelPos.x, 0, mouseRelPos.z)

	#
	# turn
	#

	var desired_facing = atan2(desired_dir.x, desired_dir.z)
	var max_facing_delta = abs(lerp_angle(facing, desired_facing, 1) - facing)
	var facing_delta = lerp_angle(facing, desired_facing, max_turn_speed) - facing # (desired_facing - facing)*max_turn_speed
	rotate_y(facing_delta)
	facing = facing + facing_delta


	#
	# move
	#

	# move in current forwards direction, not directly towards mouse
	var friction_scale = clamp(2* max_facing_delta / PI, 0, 1)
	var friction = lerp(min_friction, max_friction, friction_scale)
	friction = clampf(friction, 0, 1)

	var speed = boost_speed if boosting else base_move_speed
	self.velocity = self.velocity*friction + (1-friction)*Vector3(sin(facing), 0, cos(facing))*speed

	#
	# fire
	

	if firing:
		var current_ms = Time.get_ticks_msec()
		if current_ms - last_shot_ms > firing_interval_ms:
			last_shot_ms = current_ms

			var shot:CoinProjectile = coin_projectile_resource.instantiate()
			get_parent().add_child(shot)
			shot.scale = Vector3(1,1,1) * 0.125
			shot.velocity = self.velocity + desired_dir.normalized()*18
			shot.position = self.position + desired_dir.normalized()*0.5
			


	#
	# update player position
	#

	self.position += delta * self.velocity
