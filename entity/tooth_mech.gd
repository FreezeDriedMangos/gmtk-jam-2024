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

var desired_direction = Vector3()

var wad_projectile_resource = preload("res://entity/wad_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	base_move_speed = 5.0
	radius = 10
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_down", "ui_up"))

func _physics_process(delta: float) -> void:
	var turn_amt = deg_to_rad(CANNON_DEGREES_TURN_PER_SECOND) * delta
	var cannon := $TOOTH_MECH_queasyModel/Cannon as Node3D
	var target_pos := Vector2(target.global_position.x, target.global_position.y)
	var cannon_pos := Vector2(cannon.global_position.x, cannon.global_position.y)
	var angle := (target_pos - cannon_pos).angle()
	var angle_diff: float = angle_difference(angle, cannon.global_rotation.y)
	var angle_delta: float = -clamp(angle_diff, -turn_amt, turn_amt)

	cannon.global_rotation.y += angle_delta

	
	if firing:
		var current_ms = Time.get_ticks_msec()
		if current_ms - last_shot_ms > firing_interval_ms:
			last_shot_ms = current_ms
			fire(self.position + desired_direction.normalized()*3.5, self.velocity + desired_direction.normalized()*18)


	#set velocity based on walkingness and direction
	if walking:
		velocity = desired_direction.normalized()*base_move_speed
	else:
		velocity = Vector3(0, 0, 0)

	# move in the direction of velocity
	super(delta)

func fire(shot_position:Vector3, shot_velocity:Vector3):
	var tooth_fairy = GamestateManagerGlobal.tooth_fairy

	if tooth_fairy.teeth - 1 <= 0:
		print("out of ammo")
		return

	tooth_fairy.teeth -= 1
	var shot:WadProjectile = wad_projectile_resource.instantiate()
	get_parent().add_child(shot)
	shot.scale = Vector3(1,1,1) * 0.125
	shot.velocity = shot_velocity
	shot.position = shot_position
