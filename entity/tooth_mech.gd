class_name ToothMech extends Entity

@export var target:Entity
@export var target_locator:Node3D

const CANNON_DEGREES_TURN_PER_SECOND = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	base_move_speed = 0.1
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
