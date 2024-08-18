class_name ToothFairy extends Entity

@export var starting_distance = 70
@export var speed: float = 20
@export var boost_speed: float = 40
@export var strafe_speed: float = 5
@export var tooth_mech: Node3D

#@export var velocity = Vector3()
@export var max_turn_speed: float = 0.001
var facing: float = 0
var target_facing: float = 0
@export var turning_sensitivity: float = 0.0001

var boosting = false

func _ready() -> void:
	pass
	#self.position = tooth_mech.position + Vector3(0, 0, -self.starting_distance)
	#self.velocity = Vector3(speed, 0, 0)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if event.button_index == 0:
			boosting = event.pressed
		print("EVENT DETAILS %s %s " % [event.button_index, event.pressed])
	elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
		print("EVENT DETAILS %s %s %s" % [event.screen_velocity * turning_sensitivity, facing, target_facing])
		target_facing -= event.screen_velocity.x * turning_sensitivity
		#target_facing %= TAU
	

# redo as simple "always move forward, mouse left/right change facing dir, A/D strafe"
func _process(delta: float) -> void:
	var forwards = -self.get_global_transform().basis.z #-Vector3(sin(facing), 0, sin(facing))
	var strafe_direction = Input.get_axis("ui_left", "ui_right") * forwards
	self.position += strafe_direction * strafe_speed * delta
	
	self.position += (boost_speed if boosting else speed) * forwards * delta
	
	var last_facing = facing
	if abs(facing-target_facing) <= max_turn_speed:
		facing = target_facing
	else:
		facing = lerp(facing, target_facing, max(1, max_turn_speed*delta))
	rotate_y(facing - last_facing)
	
