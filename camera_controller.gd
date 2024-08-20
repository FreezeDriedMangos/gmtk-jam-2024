class_name CameraController extends Node3D

# needs two modes: tracking mech and tracking fairy
# needs to be able to transition between those modes
# tracking code should be essentially the same, the only difference being the offset from the target object

@export var fairy_mode: bool = true

@export var fairy_follow_speed: float = 0.3
@export var fairy_follow_rotation_speed: float = 0.6
@export var fairy_target: Node3D

@export var height = 17.5
@export var fairy: ToothFairy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fairy_mode:
		self.position = fairy.position - 0.15*fairy.velocity + Vector3(0, height, 0)
