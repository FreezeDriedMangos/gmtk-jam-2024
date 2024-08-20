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

var desired_direction = Vector2()

var wad_projectile_resource = preload("res://entity/wad_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	base_move_speed = 1.1
	radius = 10
	pass # Replace with function body.

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

	#set velocity based on walkingness and direction
	if walking:
		velocity = desired_direction*base_move_speed
	else:
		velocity = 0
	
	# move in the direction of velocity
	super(delta)
