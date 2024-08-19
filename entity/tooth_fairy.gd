class_name ToothFairy extends Entity

@export var starting_distance = 70
@export var boost_speed: float = 30
@export var strafe_speed: float = 5
@export var tooth_mech: Node3D

@export var velocity = Vector3()
@export var max_friction = 0.99
@export var min_friction = 0.9
@export var max_turn_speed: float = 0.05
var facing: float = 0
#var target_facing: float = 0
@export var turning_sensitivity: float = 0.001

@export var camera: Camera3D

var boosting = true

var mousePos_cameraRelative = Vector3()

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
		#print("EVENT DETAILS %s %s " % [event.button_index, event.pressed])
	elif event is InputEventMouseMotion:
		#target_facing -= event.relative.x * turning_sensitivity
		var rect = camera.get_viewport().size
		var selfCameraRelative = (camera.position - self.position)
		mousePos_cameraRelative = event.position - rect * 0.5 - Vector2(selfCameraRelative.x, selfCameraRelative.z)

func _process(delta: float) -> void:
	#
	# move
	#
	
	## https://stackoverflow.com/a/74972847
	#var mouse_coords = camera.get_viewport().get_mouse_position()
	#
	#var from = camera.project_ray_origin(mouse_coords)
	#var to = from + camera.project_ray_normal(mouse_coords) * 1_000
	##var space = get_world_3d().direct_space_state #get_world().direct_space_state
	##
	### ( Vector3 from, Vector3 to, Array exclude=[ ], int collision_mask=2147483647, bool collide_with_bodies=true, bool collide_with_areas=false )
	### the only thing in this layer should be our world area adjusted at character eye level
	###var intersection = space.intersect_ray(from, to, [], 32768, false, true)
	##var query = PhysicsRayQueryParameters3D.create(from, to)
	##var intersection = get_world_3d().direct_space_state.intersect_ray(query)
	#
	#var ray = to - from
	#var intersection = Vector3( )
	
	var intersection = Vector3(mousePos_cameraRelative.x, 0, mousePos_cameraRelative.y) + camera.position
	
	if intersection:
		#intersection = intersection["position"]
		#print("location %s" % intersection)
		var desired_dir = Vector3(intersection.x, 0, intersection.z) - self.position
		
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
		
		#move forward not towards mouse directly
		
		#print("%s %s %s %s" % [desired_facing, facing, facing_delta, max_facing_delta/PI]) # why does this get all the way up to 6
		var friction_scale = clamp(2* max_facing_delta / PI, 0, 1) ** 2
		var friction = lerp(min_friction, max_friction, friction_scale)
		#self.velocity *= friction
		#self.velocity += (1-friction) * desired_dir.normalized()*speed	
		var speed = boost_speed if boosting else base_move_speed
		self.velocity = self.velocity*friction + (1-friction)*Vector3(sin(facing), 0, cos(facing))*speed
		
	
	self.position += delta * self.velocity
	
#	rotation lerps towards desired facing direction (towards mouse)
#	velocity gets multiplied by 0.9 or so every frame, and 0.1*speed*desiredDir gets added every frame
#	
#	
